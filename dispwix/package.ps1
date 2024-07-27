# Copyright (c) 2024 Roger Brown.
# Licensed under the MIT License.

param(
	$CertificateThumbprint = '601A8B683F791E51F647D34AD102C38DA4DDB65F',
	$Architectures = @('arm', 'arm64', 'x86', 'x64')
)

$ProgressPreference = 'SilentlyContinue'
$ErrorActionPreference = 'Stop'

trap
{
	throw $PSItem
}

foreach ($ARCH in $Architectures)
{
	$VERSION=(Get-Item "..\bin\$ARCH\RhubarbGeekNzDllSurrogate.dll").VersionInfo.ProductVersion

	$env:PRODUCTVERSION = $VERSION
	$env:PRODUCTARCH = $ARCH
	$env:PRODUCTWIN64 = 'yes'
	$env:PRODUCTPROGFILES = 'ProgramFiles64Folder'
	$env:INSTALLERVERSION = '500'

	switch ($ARCH)
	{
		'arm64' {
			$env:UPGRADECODE = '82F03D4C-42B7-44B5-9ACB-595C0EB3FFED'
		}

		'arm' {
			$env:UPGRADECODE = 'A1ABA2A1-3C04-4B6C-A740-732C12838600'
			$env:PRODUCTWIN64 = 'no'
			$env:PRODUCTPROGFILES = 'ProgramFilesFolder'
		}

		'x86' {
			$env:UPGRADECODE = 'B0CBA6B3-70F1-4C69-8F7C-12259CD32F44'
			$env:PRODUCTWIN64 = 'no'
			$env:PRODUCTPROGFILES = 'ProgramFilesFolder'
			$env:INSTALLERVERSION = '200'
		}

		'x64' {
			$env:UPGRADECODE = '571BAE99-205F-42B9-A59C-B87A1FA5F029'
			$env:INSTALLERVERSION = '200'
		}
	}	

	& "${env:WIX}bin\candle.exe" -nologo "displib.wxs"

	if ($LastExitCode -ne 0)
	{
		exit $LastExitCode
	}

	$MsiFilename = "rhubarb-geek-nz.DllSurrogate-$VERSION-$ARCH.msi"

	& "${env:WIX}bin\light.exe" -nologo -cultures:null -out $MsiFilename 'displib.wixobj'

	if ($LastExitCode -ne 0)
	{
		exit $LastExitCode
	}

	Remove-Item 'displib.wix*'
	Remove-Item 'rhubarb-geek-nz.DllSurrogate-*.wixpdb'

	if ($CertificateThumbprint)
	{
		$codeSignCertificate = Get-ChildItem -path Cert:\ -Recurse -CodeSigningCert | Where-Object { $_.Thumbprint -eq $CertificateThumbprint }

		if ($codeSignCertificate -and ($codeSignCertificate.Count -eq 1))
		{
			$result = Set-AuthenticodeSignature -FilePath $MsiFilename -HashAlgorithm 'SHA256' -Certificate $codeSignCertificate -TimestampServer 'http://timestamp.digicert.com'
		}
		else
		{
			Write-Error "Error with certificate - $CertificateThumbprint"
		}
	}
}
