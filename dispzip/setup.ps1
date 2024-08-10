# Copyright (c) 2024 Roger Brown.
# Licensed under the MIT License.

param([switch]$UnregServer)

trap
{
	throw $PSItem
}

$ErrorActionPreference = [System.Management.Automation.ActionPreference]::Stop

$ProcessArchitecture = $Env:PROCESSOR_ARCHITECTURE.ToLower()

switch ($ProcessArchitecture)
{
	'amd64' { $ProcessArchitecture = 'x64' }
}

$ProgramFiles = $Env:ProgramFiles

$CompanyDir = Join-Path -Path $ProgramFiles -ChildPath 'rhubarb-geek-nz'
$ProductDir = Join-Path -Path $CompanyDir -ChildPath 'DllSurrogate'
$InstallDir = Join-Path -Path $ProductDir -ChildPath $ProcessArchitecture
$DllName = 'RhubarbGeekNzDllSurrogate.dll'
$DllPath = Join-Path -Path $InstallDir -ChildPath $DllName

$CLSID = '{155FEAE5-9586-4FFF-8CE3-BB603ABFAACC}'
$LIBID = '{E78F53BC-8BD5-41D9-9397-A0D8DECD1295}'
$LIBVER = '0.0'
$IID = '{C976DA40-D2D1-40A3-A40B-12AB0ED3ABE9}'
$PROGID = 'RhubarbGeekNz.DllSurrogate'
$APPID = '{B3958571-4AE6-49C9-A93A-E0B6AE6D13EE}'

if ($UnregServer)
{
	$DllPath, $InstallDir, $ProductDir | ForEach-Object {
		$FilePath = $_
		if (Test-Path $FilePath)
		{
			Remove-Item -LiteralPath $FilePath
		}
	}

	if (Test-Path $CompanyDir)
	{
		$children = Get-ChildItem -LiteralPath $CompanyDir

		if (-not $children)
		{
			Remove-Item -LiteralPath $CompanyDir
		}
	}

	foreach ($RegistryPath in 
		"HKLM:\SOFTWARE\Classes\CLSID\$CLSID\InprocServer32",
		"HKLM:\SOFTWARE\Classes\CLSID\$CLSID",
		"HKLM:\SOFTWARE\Classes\$PROGID\CLSID",
		"HKLM:\SOFTWARE\Classes\$PROGID",
		"HKLM:\SOFTWARE\Classes\TypeLib\$LIBID\$LIBVER\0\win32",
		"HKLM:\SOFTWARE\Classes\TypeLib\$LIBID\$LIBVER\0\win64",
		"HKLM:\SOFTWARE\Classes\TypeLib\$LIBID\$LIBVER\0",
		"HKLM:\SOFTWARE\Classes\TypeLib\$LIBID\$LIBVER\FLAGS",
		"HKLM:\SOFTWARE\Classes\TypeLib\$LIBID\$LIBVER\HELPDIR",
		"HKLM:\SOFTWARE\Classes\TypeLib\$LIBID\$LIBVER",
		"HKLM:\SOFTWARE\Classes\TypeLib\$LIBID",
		"HKLM:\SOFTWARE\Classes\Interface\$IID\ProxyStubClsid32",
		"HKLM:\SOFTWARE\Classes\Interface\$IID\ProxyStubClsid",
		"HKLM:\SOFTWARE\Classes\Interface\$IID\TypeLib",
		"HKLM:\SOFTWARE\Classes\Interface\$IID",
		"HKLM:\SOFTWARE\Classes\AppID\$APPID"
	)
	{
		if (Test-Path $RegistryPath)
		{
			Remove-Item -Path $RegistryPath
		}
	}
}
else
{
	if (Test-Path $DllPath)
	{
		Write-Warning "$DllPath is already installed"
	}
	else
	{
		$SourceDir = Join-Path -Path $PSScriptRoot -ChildPath $ProcessArchitecture
		$SourceFile = Join-Path -Path $SourceDir -ChildPath $DllName

		if (-not (Test-Path $SourceFile))
		{
			Write-Error "$SourceFile does not exist"
		}
		else
		{
			$CompanyDir, $ProductDir, $InstallDir | ForEach-Object {
				$FilePath = $_
				if (-not (Test-Path $FilePath))
				{
					$Null = New-Item -Path $FilePath -ItemType 'Directory'
				}
			}

			Copy-Item $SourceFile $DllPath
		}

		$RegistryPath = "HKLM:\SOFTWARE\Classes\CLSID\$CLSID\InprocServer32"

		if (Test-Path $RegistryPath)
		{
			$null = Set-Item -Path $RegistryPath -Value $DllPath
		}
		else
		{
			$null = New-Item -Path $RegistryPath -Value $DllPath -Force
		}

		$null = New-ItemProperty -Path $RegistryPath -Name 'ThreadingModel' -Value 'Both' -PropertyType 'String'

		$RegistryPath = "HKLM:\SOFTWARE\Classes\CLSID\$CLSID"

		$null = New-ItemProperty -Path $RegistryPath -Name 'AppID' -Value $APPID -PropertyType 'String'

		$RegistryPath = "HKLM:\SOFTWARE\Classes\$PROGID\CLSID"

		if (Test-Path $RegistryPath)
		{
			$null = Set-Item -Path $RegistryPath -Value $CLSID
		}
		else
		{
			$null = New-Item -Path $RegistryPath -Value $CLSID -Force
		}

		$RegistryPath = "HKLM:\SOFTWARE\Classes\Interface\$IID\ProxyStubClsid32"

		if (Test-Path $RegistryPath)
		{
			$null = Set-Item -Path $RegistryPath -Value '{00020424-0000-0000-C000-000000000046}'
		}
		else
		{
			$null = New-Item -Path $RegistryPath -Value '{00020424-0000-0000-C000-000000000046}' -Force
		}

		$RegistryPath = "HKLM:\SOFTWARE\Classes\Interface\$IID\TypeLib"

		if (Test-Path $RegistryPath)
		{
			$null = Set-Item -Path $RegistryPath -Value $LIBID
		}
		else
		{
			$null = New-Item -Path $RegistryPath -Value $LIBID -Force
		}

		$null = New-ItemProperty -Path $RegistryPath -Name 'Version' -Value $LIBVER -PropertyType 'String'

		$RegistryPath = "HKLM:\SOFTWARE\Classes\AppID\$APPID"

		if (-not (Test-Path $RegistryPath))
		{
			$null = New-Item -Path $RegistryPath
		}

		$null = New-ItemProperty -Path $RegistryPath -Name 'DllSurrogate' -Value '' -PropertyType 'String'

		Add-Type -TypeDefinition @"
			using System;
			using System.ComponentModel;
			using System.Runtime.InteropServices;

			namespace RhubarbGeekNz.DllSurrogate
			{
				public class InterOp
				{
					[DllImport("oleaut32.dll", CharSet = CharSet.Unicode, PreserveSig = false)]
					private static extern void LoadTypeLibEx(string szFile, uint regkind, out IntPtr pptlib);

					public static void RegisterTypeLib(string path)
					{
						IntPtr punk;
						LoadTypeLibEx(path, 1, out punk);
						Marshal.Release(punk);
					}
				}
			}
"@

		[RhubarbGeekNz.DllSurrogate.InterOp]::RegisterTypeLib($DllPath)
	}
}
