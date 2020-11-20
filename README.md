# NimbleMusings

Musings with Nim, a central repository with code snippets as I explore Nim and
research what it brings to the table for red team tool development.



### injector_nim/crtinjection.nim

crtinjection.nim is a standard crt injector with notepad shellcode.


dynlib_crtinjection.nim also performs crt injection; however, uses dynlib to dynamically invoke API calls.



### NimScriptembedded/messagebox.nim

Using [nimscripter](https://github.com/beef331/nimscripter) to expose a Nim proc to call
MessageBoxA and invoke it via NimScript.


### NimSharpSploitMap

C# program to manually map compiled DLL from Nim that exports inject proc that performs crt injection.