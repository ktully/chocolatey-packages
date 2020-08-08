$ErrorActionPreference = 'Stop'; # stop on all errors

$packageName= 'glaryutilities-free' # arbitrary name for the package, used in messages
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url         = 'https://download.glarysoft.com/gu5setup.exe'
$checksum    = '9030E39AF12672B49C367D58742E870BFEB4A1256BBC94AB89D31D0646BED3E4'

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
