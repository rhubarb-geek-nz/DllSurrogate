# Copyright (c) 2024 Roger Brown.
# Licensed under the MIT License.

param(
	$ProgID = 'RhubarbGeekNz.DllSurrogate',
	$Method = 'GetMessage',
	$Hint = @(1, 2, 3, 4, 5)
)

Add-Type -TypeDefinition @"
	using System;
	using System.Runtime.InteropServices;

	namespace RhubarbGeekNz.DllSurrogate
	{
		public class InterOp
		{
			public static object CreateInstance(string progId)
			{
				CLSIDFromProgID(progId, out Guid clsid);
				CoCreateInstance(clsid, IntPtr.Zero, 4, IID_IDispatch, out object dispatch);
				return dispatch;
			}

			[DllImport("ole32.dll", PreserveSig = false)]
			static extern int CoCreateInstance([In, MarshalAs(UnmanagedType.LPStruct)] Guid rclsid,
				IntPtr pUnkOuter, UInt32 dwClsContext, [In, MarshalAs(UnmanagedType.LPStruct)] Guid riid,
				[MarshalAs(UnmanagedType.IUnknown)] out object ppv);

			[DllImport("ole32.dll", PreserveSig = false)]
			static extern int CLSIDFromProgID([MarshalAs(UnmanagedType.LPWStr)] string lpszProgID, out Guid pclsid);

			static readonly Guid IID_IDispatch = Guid.Parse("00020400-0000-0000-C000-000000000046");
		}
	}
"@

$helloWorld = [RhubarbGeekNz.DllSurrogate.InterOp]::CreateInstance($ProgID)

foreach ($h in $hint)
{
	$result = $helloWorld.$Method($h)

	"$h $result"
}
