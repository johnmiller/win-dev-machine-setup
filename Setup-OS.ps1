function configureWindowsExplorer() {
    Write-Host "Configuring windows explorer"
    $key = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"
    
    Write-Host "Enabling showing hidden files"
    Set-ItemProperty $key Hidden 1
    
    Write-Host "Disabling hiding extensions for known files"
    Set-ItemProperty $key HideFileExt 0
    
    Write-Host "Disabling showing hidden operation system files"
    Set-ItemProperty $key ShowSuperHidden 0
    
    Write-Host "Restarting explorer shell to apply registry changes"
    Stop-Process -processname explorer
}

function configurePowershell() {
    Set-ExecutionPolicy unrestricted

    Write-Information "Enable console prompting for PowerShell"
    Set-ItemProperty "HKLM:\SOFTWARE\Microsoft\PowerShell\1\ShellIds" -Name "ConsolePrompting" -Value $True
}

function installChocolatey() {
    Write-Information "Installing chocolatey"
    Invoke-Expression ((new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1'))
}

function enableWindowsFeatures() {
    Write-Information "Installing .Net frameworks and IIS"
    Enable-WindowsOptionalFeature -FeatureName NetFx3 -Online -NoRestart
    Enable-WindowsOptionalFeature -FeatureName WCF-Services45 -Online -NoRestart
    Enable-WindowsOptionalFeature -FeatureName WCF-TCP-PortSharing45 -Online -NoRestart
    Enable-WindowsOptionalFeature -FeatureName NetFx4-AdvSrvs -Online -NoRestart
    Enable-WindowsOptionalFeature -FeatureName NetFx4Extended-ASPNET45 -Online -NoRestart
    Enable-WindowsOptionalFeature -FeatureName Windows-Identity-Foundation -Online -NoRestart
    dism /Online /Enable-Feature /All /FeatureName:IIS-WebServer
    dism /Online /Enable-Feature /All /FeatureName:IIS-ASPNET45
    dism /Online /Enable-Feature /All /FeatureName:WCF-HTTP-Activation45 

    Write-Information "Enabling Windows Subsystem for Linux"
    Enable-WindowsOptionalFeature -FeatureName Microsoft-Windows-Subsystem-Linux -Online -NoRestart

    Write-Information "Enabling Hyper-V features"
    Enable-WindowsOptionalFeature -FeatureName Microsoft-Hyper-V-All -Online -NoRestart

    Write-Information "Enabling Containers"
    Enable-WindowsOptionalFeature -FeatureName Containers -Online -NoRestart
}

configurePowershell
installChocolatey
enableWindowsFeatures
configureWindowsExplorer

Write-Host ""
Write-Host "Installation of OS components completed, please restart your computer once ready!"
Write-Host ""
