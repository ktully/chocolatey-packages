import-module au

# convert Windows .ini file contents into a hash
# adapted from Oliver Lipkau's Get-IniContent()
# https://gallery.technet.microsoft.com/scriptcenter/ea40c1ef-c856-434b-b8fb-ebd7a76e8d91
# https://devblogs.microsoft.com/scripting/use-powershell-to-work-with-any-ini-file/
function Get-IniContent ($iniValue)
{
    $ini = @{}
    
    ForEach ($line in $($iniValue -split "\r?\n|\r")) { 
        switch -regex ($line)
        {
            “^\[(.+)\]” # Section
            {
                $section = $matches[1]
                $ini[$section] = @{}
                $CommentCount = 0
            }
            “^(;.*)$” # Comment
            {
                $value = $matches[1]
                $CommentCount = $CommentCount + 1
                $name = “Comment” + $CommentCount
                $ini[$section][$name] = $value.Trim()
            }
            “(.+?)\s*=(.*)” # Key
            {
                $name,$value = $matches[1..2]
                $ini[$section][$name] = $value.Trim()
            }
        }
    }
    return $ini
}


# as used by app when user clicks "Check for updates"
$checkForUpdatesUrl = 'https://www.glarysoft.com/update/update.php?s=glary_utilities&c=10000&ft=std'

function global:au_GetLatest {
    $updateIniValue = Invoke-WebRequest -Uri $checkForUpdatesUrl -UseBasicParsing # returns .ini file layout
    $updateIni = Get-IniContent($updateIniValue)

    $url = $updateIni["Version"]["UpdateUrl"]
    $version = $updateIni["Version"]["Version"]

    $Latest = @{ URL32 = $url; Version = $version }
    return $Latest
}

function global:au_SearchReplace {
    @{
        'tools\chocolateyInstall.ps1' = @{
            "(^[$]checksum\s*=\s*)('.*')"  = "`$1'$($Latest.Checksum32)'"
        }

        "$($Latest.PackageName).nuspec" = @{
            "(/release-notes/gu/)(.*)(</releaseNotes>)" = "`${1}$($Latest.Version)`$3"
        }
    }
}

update -NoCheckUrl -ChecksumFor 32
