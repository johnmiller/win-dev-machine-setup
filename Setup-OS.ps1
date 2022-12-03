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

function installGit() {
    Write-Information "Installing git"
    winget install --source winget --silent "Git.Git"
    winget install --source winget --silent "Git Large File Storage"

    . $PSScriptRoot\Refresh-EnvironmentVariables
}

function enableWindowsFeatures() {
    Write-Host "Enabling IIS features"
    # .NET Framework 3.5 (includes .NET 2.0 and 3.0)
    Enable-WindowsOptionalFeature -FeatureName NetFx3 -Online -NoRestart -All
    Enable-WindowsOptionalFeature -FeatureName WCF-HTTP-Activation -Online -NoRestart -All
    Enable-WindowsOptionalFeature -FeatureName WCF-NonHTTP-Activation -Online -NoRestart -All
    # .NET Framework 4.8 Advanced Services
    Enable-WindowsOptionalFeature -FeatureName NetFx4-AdvSrvs -Online -NoRestart -All
    Enable-WindowsOptionalFeature -FeatureName NetFx4Extended-ASPNET45 -Online -NoRestart -All
    # .NET Framework 4.8 Advanced Services -> WCF Services
    Enable-WindowsOptionalFeature -FeatureName WCF-Services45 -Online -NoRestart -All
    Enable-WindowsOptionalFeature -FeatureName WCF-HTTP-Activation45 -Online -NoRestart -All
    Enable-WindowsOptionalFeature -FeatureName WCF-TCP-PortSharing45 -Online -NoRestart -All
    # Internet Information Services -> Web Management Tools
    Enable-WindowsOptionalFeature -FeatureName IIS-WebServerManagementTools -Online -NoRestart -All
    Enable-WindowsOptionalFeature -FeatureName IIS-ManagementConsole -Online -NoRestart -All
    Enable-WindowsOptionalFeature -FeatureName IIS-ManagementScriptingTools -Online -NoRestart -All
    # Internet Information Services -> Web Management Tools -> IIS 6 Management Console
    Enable-WindowsOptionalFeature -FeatureName IIS-IIS6ManagementCompatibility -Online -NoRestart -All
    Enable-WindowsOptionalFeature -FeatureName IIS-LegacySnapIn -Online -NoRestart -All
    Enable-WindowsOptionalFeature -FeatureName IIS-LegacyScripts -Online -NoRestart -All
    Enable-WindowsOptionalFeature -FeatureName IIS-WMICompatibility -Online -NoRestart -All
    Enable-WindowsOptionalFeature -FeatureName IIS-Metabase -Online -NoRestart -All
    # Internet Information Services -> World Wide Web Services -> Application Development Features
    Enable-WindowsOptionalFeature -FeatureName IIS-NetFxExtensibility -Online -NoRestart -All
    Enable-WindowsOptionalFeature -FeatureName IIS-NetFxExtensibility45 -Online -NoRestart -All
    Enable-WindowsOptionalFeature -FeatureName IIS-ASPNET -Online -NoRestart -All
    Enable-WindowsOptionalFeature -FeatureName IIS-ASPNET45 -Online -NoRestart -All
    Enable-WindowsOptionalFeature -FeatureName IIS-ISAPIExtensions -Online -NoRestart -All
    Enable-WindowsOptionalFeature -FeatureName IIS-ISAPIFilter -Online -NoRestart -All
    # Internet Information Services -> World Wide Web Services -> Common HTTP Features
    Enable-WindowsOptionalFeature -FeatureName IIS-DefaultDocument -Online -NoRestart -All
    Enable-WindowsOptionalFeature -FeatureName IIS-DirectoryBrowsing -Online -NoRestart -All
    Enable-WindowsOptionalFeature -FeatureName IIS-HttpErrors -Online -NoRestart -All
    Enable-WindowsOptionalFeature -FeatureName IIS-HttpRedirect -Online -NoRestart -All
    Enable-WindowsOptionalFeature -FeatureName IIS-StaticContent -Online -NoRestart -All
    Enable-WindowsOptionalFeature -FeatureName IIS-WebDAV -Online -NoRestart -All
    # Internet Information Services -> World Wide Web Services -> Health and Diagnostics
    Enable-WindowsOptionalFeature -FeatureName IIS-HttpLogging -Online -NoRestart -All
    Enable-WindowsOptionalFeature -FeatureName IIS-RequestMonitor -Online -NoRestart -All
    # Internet Information Services -> World Wide Web Services -> Performance Features
    Enable-WindowsOptionalFeature -FeatureName IIS-HttpCompressionStatic -Online -NoRestart -All
    # Internet Information Services -> World Wide Web Services -> Security
    Enable-WindowsOptionalFeature -FeatureName IIS-RequestFiltering -Online -NoRestart -All
    Enable-WindowsOptionalFeature -FeatureName IIS-URLAuthorization -Online -NoRestart -All
    Enable-WindowsOptionalFeature -FeatureName IIS-WindowsAuthentication -Online -NoRestart -All
    # Windows Identity Foundation 3.5
    Enable-WindowsOptionalFeature -FeatureName Windows-Identity-Foundation -Online -NoRestart -All
    # Windows Process Activation Service
    Enable-WindowsOptionalFeature -FeatureName WAS-WindowsActivationService -Online -NoRestart -All
    Enable-WindowsOptionalFeature -FeatureName WAS-ProcessModel -Online -NoRestart -All
    Enable-WindowsOptionalFeature -FeatureName WAS-NetFxEnvironment -Online -NoRestart -All
    Enable-WindowsOptionalFeature -FeatureName WAS-ConfigurationAPI -Online -NoRestart -All

    Write-Host "Enabling Windows Subsystem for Linux"
    Enable-WindowsOptionalFeature -FeatureName Microsoft-Windows-Subsystem-Linux -Online -NoRestart

    #Write-Host "Enabling Hyper-V features"
    #Enable-WindowsOptionalFeature -FeatureName Microsoft-Hyper-V-All -Online -NoRestart

    #Write-Host "Enabling Containers"
    #Enable-WindowsOptionalFeature -FeatureName Containers -Online -NoRestart
}


configurePowershell
enableWindowsFeatures
configureWindowsExplorer

Write-Host ""
Write-Host "Installation of OS components completed, please restart your computer once ready!"
Write-Host ""
