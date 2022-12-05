Write-Host "Installing posh-git...."
Install-Module -Name posh-git -Force

Write-Host "Installing oh-my-posh..."
winget install --silent --source winget --id JanDeDobbeleer.OhMyPosh

Write-Host "Installing PSReadLine..."
Install-Module -Name PSReadLine -SkipPublisherCheck -Force

. $PSScriptRoot\Refresh-EnvironmentVariables

# Then write to the PowerShell Profile
if ( ! [System.IO.File]::Exists($PROFILE) ) {
    $f = [System.IO.File]::CreateText($PROFILE)
    $f.Close()
}

# A bit hacky, but this is a bit of spare-time, hence limited time to optimize:)
$profileContent = Get-Content -Raw -Path $PROFILE
if ( [System.String]::IsNullOrEmpty($profileContent) ) { $profileContent = "" }
if ( ! $profileContent.Contains("posh-git") ) { Add-Content -Path $PROFILE -Value 'Import-Module posh-git' }
if ( ! $profileContent.Contains("shellName") ) { Add-Content -Path $PROFILE -Value '$shellName = $(oh-my-posh get shell)' }
if ( ! $profileContent.Contains("oh-my-posh") ) { Add-Content -Path $PROFILE -Value 'oh-my-posh init $shellName --config "$env:POSH_THEMES_PATH\iterm2.omp.json" | Invoke-Expression' }

# Install the fonts with oh-my-posh
oh-my-posh font install Meslo
oh-my-posh font install CascadiaCode
. $PSScriptRoot\Refresh-EnvironmentVariables