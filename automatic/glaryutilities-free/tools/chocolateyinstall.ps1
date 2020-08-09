$ErrorActionPreference = 'Stop'; # stop on all errors

$packageName= 'glaryutilities-free' # arbitrary name for the package, used in messages
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url         = 'http://download.glarysoft.com/gu5setup.exe'
$checksum    = '9030e39af12672b49c367d58742e870bfeb4a1256bbc94ab89d31d0646bed3e4'

$packageArgs = @{
  packageName   = $packageName
  unzipLocation = $toolsDir
  fileType      = 'EXE'
  url           = $url

  softwareName  = 'Glary Utilities'

  checksum       = $checksum
  checksumType   = 'sha256'
  
  validExitCodes= @(0, 3010, 1641)
  silentArgs   = '/S  /NORESTART '
}

Install-ChocolateyPackage @packageArgs
