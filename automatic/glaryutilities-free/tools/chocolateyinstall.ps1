$ErrorActionPreference = 'Stop'; # stop on all errors

$packageName= 'glaryutilities-free' # arbitrary name for the package, used in messages
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$fileLocation = Join-Path $toolsDir 'gu5setup.exe'
# Note https://www.glarysoft.com/inf/eula/ allows redistribution of this freeware installer
# "Evaluation versions available for download from Glarysoft’s websites may be freely distributed."

$packageArgs = @{
  packageName   = $packageName
  fileType      = 'exe'
  file          = $fileLocation
  softwareName  = 'Glary Utilities'

  validExitCodes= @(0, 3010, 1641)
  silentArgs   = '/S  /NORESTART '
}

Install-ChocolateyInstallPackage @packageArgs