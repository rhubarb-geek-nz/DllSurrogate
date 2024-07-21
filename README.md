# rhubarb-geek-nz/DllSurrogate

Demonstration of in-process server object running in a COM Surrogate process.

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
