import nimscripted
import winim/lean
import dynlib

proc callMessage(libPath: string, libFunc: string, message: string): int {.exportToScript.} =
    type messageboxaType = proc(hWnd: HWND, lpText: LPCSTR, lpCaption: LPCSTR, uType: UINT): int32 {.gcsafe, stdcall.}
    let lib = loadLib(libPath)
    if lib != nil:
        let messageboxa = cast[messageboxaType](lib.symAddr(libFunc))
        var hWnd: HWND
        let options = 0
        discard messageboxa(hWnd, cast[LPCSTR](cstring(message)), cast[LPCSTR](cstring(message)), UINT(options))
        return 1
    return 0

import nimscripter
let code = """let message = if defined(windows): "Windows" elif defined(linux): "Linux" else: "macOS" """ & 
"\n" &
 """discard callMessage(r"C:\Win" & r"dows\Sys" & r"tem32\" & "user3" & "2." & "dl" & "l", "MessageBoxA", message & " is a nice OS")"""
discard loadScript(code, false)
