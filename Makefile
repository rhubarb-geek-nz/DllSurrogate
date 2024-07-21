# Copyright (c) 2024 Roger Brown.
# Licensed under the MIT License.

BINDIR=bin\$(VSCMD_ARG_TGT_ARCH)
APPNAME=dispapp
LIBNAME=displib

all: $(BINDIR) $(BINDIR)\$(LIBNAME).dll $(BINDIR)\$(APPNAME).exe

clean:
	if exist $(BINDIR) rmdir /q /s $(BINDIR)
	cd $(LIBNAME)
	$(MAKE) clean
	cd ..
	cd $(APPNAME)
	$(MAKE) clean
	cd ..

$(BINDIR):
	mkdir $@

$(BINDIR)\$(APPNAME).exe: $(APPNAME)\$(BINDIR)\$(APPNAME).exe
	copy $(APPNAME)\$(BINDIR)\$(APPNAME).exe $@

$(BINDIR)\$(LIBNAME).dll: $(LIBNAME)\$(BINDIR)\$(LIBNAME).dll
	copy $(LIBNAME)\$(BINDIR)\$(LIBNAME).dll $@

$(APPNAME)\$(BINDIR)\$(APPNAME).exe:
	cd $(APPNAME)
	$(MAKE) CertificateThumbprint=$(CertificateThumbprint)
	cd ..

$(LIBNAME)\$(BINDIR)\$(LIBNAME).dll:
	cd $(LIBNAME)
	$(MAKE) CertificateThumbprint=$(CertificateThumbprint)
	cd ..
