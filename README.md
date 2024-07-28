# rhubarb-geek-nz/DllSurrogate

Demonstration of in-process server object running in a COM Surrogate process.

The CLSID is configured to run in an AppID with a DllSurrogate value.

```
Windows Registry Editor Version 5.00

[HKEY_CLASSES_ROOT\RhubarbGeekNz.DllSurrogate\CLSID]
@="{155FEAE5-9586-4FFF-8CE3-BB603ABFAACC}"

[HKEY_CLASSES_ROOT\CLSID\{155FEAE5-9586-4FFF-8CE3-BB603ABFAACC}]
"AppID"="{B3958571-4AE6-49C9-A93A-E0B6AE6D13EE}"

[HKEY_CLASSES_ROOT\CLSID\{155FEAE5-9586-4FFF-8CE3-BB603ABFAACC}\InprocServer32]
@="C:\\PROGRA~1\\RHUBAR~1\\DLLSUR~1\\x64\\RHUBAR~1.DLL"
"ThreadingModel"="Both"

[HKEY_CLASSES_ROOT\AppID\{B3958571-4AE6-49C9-A93A-E0B6AE6D13EE}]
"DllSurrogate"=""
```

[displib.idl](displib/displib.idl) defines the dual-interface for a simple local server.

[displib.c](displib/displib.c) implements the interface.

[dispapp.cpp](dispapp/dispapp.cpp) creates an instance with [CoCreateInstance](https://learn.microsoft.com/en-us/windows/win32/api/combaseapi/nf-combaseapi-cocreateinstance) and uses it to get a message to display.

[package.ps1](package.ps1) is used to automate the building of multiple architectures.

Response from server shows it is implemented in a `dll` and running in `dllhost.exe`.

```
D:\TMP>bin\x64\dispapp.exe 4
C:\PROGRA~1\RHUBAR~1\DLLSUR~1\displib.dll

D:\TMP>bin\x64\dispapp.exe 5
C:\Windows\system32\DllHost.exe
```
