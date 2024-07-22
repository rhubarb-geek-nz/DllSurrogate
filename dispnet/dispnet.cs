/***********************************
 * Copyright (c) 2024 Roger Brown.
 * Licensed under the MIT License.
 ****/

using System;
using System.Linq;
using System.Runtime.InteropServices;

namespace RhubarbGeekNz.DllSurrogate
{
    internal class Program
    {
        static void Main(string[] args)
        {
            CLSIDFromProgID("RhubarbGeekNz.DllSurrogate", out Guid clsid);

            CoCreateInstance(clsid, IntPtr.Zero, 4, IID_IDispatch, out object dispatch);

            IHelloWorld helloWorld = dispatch as IHelloWorld;

            foreach (int hint in args.Length == 0 ? new int[] { 1, 2, 3, 4, 5 } : args.Select(t => Int32.Parse(t)).ToArray())
            {
                string result = helloWorld.GetMessage(hint);
                Console.WriteLine($"{hint} {result}");
            }
        }

        [DllImport("ole32.dll", PreserveSig = false)]
        static extern int CoCreateInstance([In, MarshalAs(UnmanagedType.LPStruct)] Guid rclsid,
           IntPtr pUnkOuter, UInt32 dwClsContext, [In, MarshalAs(UnmanagedType.LPStruct)] Guid riid,
           [MarshalAs(UnmanagedType.IUnknown)] out object ppv);

        [DllImport("ole32.dll", PreserveSig = false)]
        static extern int CLSIDFromProgID([MarshalAs(UnmanagedType.LPWStr)] string lpszProgID, out Guid pclsid);

        static Guid IID_IDispatch = Guid.Parse("00020400-0000-0000-C000-000000000046");
    }
}
