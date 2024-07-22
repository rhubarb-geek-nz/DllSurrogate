/***********************************
 * Copyright (c) 2024 Roger Brown.
 * Licensed under the MIT License.
 ****/

using System;
using System.Linq;

namespace RhubarbGeekNz.DllSurrogate
{
    internal class Program
    {
        static void Main(string[] args)
        {
            IHelloWorld helloWorld = Activator.CreateInstance(Type.GetTypeFromProgID("RhubarbGeekNz.DllSurrogate")) as IHelloWorld;

            foreach (int hint in args.Length == 0 ? new int[] { 1, 2, 3, 4, 5 } : args.Select(t => Int32.Parse(t)).ToArray())
            {
                string result = helloWorld.GetMessage(hint);
                Console.WriteLine($"{hint} {result}");
            }
        }
    }
}
