/***********************************
 * Copyright (c) 2024 Roger Brown.
 * Licensed under the MIT License.
 ****/

using System;
using System.Linq;
using System.Runtime.InteropServices;

namespace RhubarbGeekNzDllSurrogate
{
    internal class Program
    {
        static void Main(string[] args)
        {
            Guid clsid = Type.GetTypeFromProgID("RhubarbGeekNz.DllSurrogate").GUID;

            foreach (uint clsctx in new uint[] { 4, 1 })
            {
                CoCreateInstance(clsid, IntPtr.Zero, clsctx, typeof(IHelloWorld).GUID, out object server);

                IHelloWorld helloWorld = server as IHelloWorld;

                foreach (int hint in args.Length == 0 ? new int[] { 1, 2, 3, 4, 5 } : args.Select(t => Int32.Parse(t)).ToArray())
                {
                    string result = helloWorld.GetMessage(hint);
                    Console.WriteLine($"{clsctx} {hint} {result}");
                }
            }
        }

        [DllImport("ole32.dll", PreserveSig = false)]
        static extern void CoCreateInstance([In, MarshalAs(UnmanagedType.LPStruct)] Guid rclsid,
           IntPtr pUnkOuter, UInt32 dwClsContext, [In, MarshalAs(UnmanagedType.LPStruct)] Guid riid,
           [MarshalAs(UnmanagedType.IUnknown)] out object ppv);
    }
}
