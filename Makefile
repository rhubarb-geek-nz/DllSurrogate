# Copyright (c) 2024 Roger Brown.
# Licensed under the MIT License.

BINDIR=bin\$(VSCMD_ARG_TGT_ARCH)
APPNAME=dispapp
LIBNAME=displib
TLBNAME=disptlb

all: $(BINDIR) $(BINDIR)\$(LIBNAME).dll $(BINDIR)\$(TLBNAME).dll $(BINDIR)\$(APPNAME).exe

clean:
	if exist $(BINDIR) rmdir /q /s $(BINDIR)
	cd $(LIBNAME)
	$(MAKE) clean
	cd ..
	cd $(APPNAME)
	$(MAKE) clean
	cd ..
	cd $(TLBNAME)
	$(MAKE) clean
	cd ..

$(BINDIR):
	mkdir $@

$(BINDIR)\$(APPNAME).exe: $(APPNAME)\$(BINDIR)\$(APPNAME).exe
	copy $(APPNAME)\$(BINDIR)\$(APPNAME).exe $@

$(BINDIR)\$(LIBNAME).dll: $(LIBNAME)\$(BINDIR)\$(LIBNAME).dll
	copy $(LIBNAME)\$(BINDIR)\$(LIBNAME).dll $@

$(BINDIR)\$(TLBNAME).dll: $(TLBNAME)\$(BINDIR)\$(TLBNAME).dll
	copy $(TLBNAME)\$(BINDIR)\$(TLBNAME).dll $@

$(APPNAME)\$(BINDIR)\$(APPNAME).exe:
	cd $(APPNAME)
	$(MAKE) CertificateThumbprint=$(CertificateThumbprint)
	cd ..

$(LIBNAME)\$(BINDIR)\$(LIBNAME).dll:
	cd $(LIBNAME)
	$(MAKE) CertificateThumbprint=$(CertificateThumbprint)
	cd ..

$(TLBNAME)\$(BINDIR)\$(TLBNAME).dll:
	cd $(TLBNAME)
	$(MAKE) CertificateThumbprint=$(CertificateThumbprint)
	cd ..
