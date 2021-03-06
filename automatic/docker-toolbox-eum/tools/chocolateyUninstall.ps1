﻿$ErrorActionPreference = 'Stop'; # stop on all errors

$packageName = 'docker-toolbox-eum'
$softwareName = 'Docker Toolbox*' #part or all of the Display Name as you see it in Programs and Features. It should be enough to be unique
$installerType = 'EXE'

#$silentArgs = '/qn /norestart'
# https://msdn.microsoft.com/en-us/library/aa376931(v=vs.85).aspx
#$validExitCodes = @(0, 3010, 1605, 1614, 1641)

$silentArgs = '/VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-' # Inno Setup
$validExitCodes = @(0)

$uninstalled = $false

[array]$key = Get-UninstallRegistryKey -SoftwareName $softwareName

if ($key.Count -eq 1) {
  $key | % {
    $file = "$($_.UninstallString)"

    Uninstall-ChocolateyPackage -PackageName $packageName `
                                -FileType $installerType `
                                -SilentArgs "$silentArgs" `
                                -ValidExitCodes $validExitCodes `
                                -File "$file"

    Install-ChocolateyEnvironmentVariable -VariableName "DOCKER_TOOLBOX_INSTALL_PATH" -VariableValue $null  -VariableType 'Machine'
  }
} elseif ($key.Count -eq 0) {
  Write-Warning "$packageName has already been uninstalled by other means."
} elseif ($key.Count -gt 1) {
  Write-Warning "$key.Count matches found!"
  Write-Warning "To prevent accidental data loss, no programs will be uninstalled."
  Write-Warning "Please alert package maintainer the following keys were matched:"
  $key | % {Write-Warning "- $_.DisplayName"}
}
