. $PSScriptRoot\HelperLibrary.ps1

Install-WingetPackage -Name "Java 8"
Install-WingetPackage -Name "Wireshark"
Install-WingetPackage -Name "Sysinternals Suite" -Source msstore
Install-WingetPackage -Name "jq"
Install-WingetPackage -Name "OpenSSL"
Install-WingetPackage -Name "Postman.Postman"
Install-WingetPackage -Name "Microsoft.VisualStudioCode"
Install-WingetPackage -Name "Notepad++.Notepad++"
Install-WingetPackage -Name "SmartBear.SoapUI"

Write-StepStatus "Installing wsl kernal update"
Invoke-WebRequest https://wslstorestorage.blob.core.windows.net/wslblob/wsl_update_x64.msi -OutFile "$env:TEMP\wsl_update_x64.msi"
msiexec /i "$env:TEMP\wsl_update_x64.msi" /passive
Install-WingetPackage -Name "Ubuntu" -Source msstore
Install-WingetPackage -Name "Ubuntu 18.04.5 LTS" -Source msstore

Install-WingetPackage -Name "Docker.DockerDesktop"
Refresh-EnvironmentVariables

Install-WingetPackage -Name "Microsoft.DotNet.SDK.6"
Install-WingetPackage -Name "Microsoft.DotNet.SDK.3_1"
Install-WingetPackage -Name "Microsoft.OpenJDK.16"
Install-WingetPackage -Name "GoLang.Go.1.19"
Install-WingetPackage -Name "Python.Python.3.9"
Install-WingetPackage -Name "OpenJS.NodeJS"
Install-WingetPackage -Name "RubyInstallerTeam.RubyWithDevKit.3.1"
Refresh-EnvironmentVariables

Install-WingetPackage -Name "LINQPad 7"
Install-WingetPackage -Name "Microsoft.AzureCLI"
Install-WingetPackage -Name "Amazon.AWSCLI"
Install-WingetPackage -Name "GitKraken"
Install-WingetPackage -Name "NuGet"
Install-WingetPackage -Name "Microsoft.SQLServer.2019.Developer" #Installer failed with exit code: 3010
Install-WingetPackage -Name "Microsoft.SQLServerManagementStudio"
Install-WingetPackage -Name "ExifTool"
Refresh-EnvironmentVariables

Write-StepStatus ""
Write-StepStatus "Installation of dev tools complete, please restart your computer before moving to the next step."
Write-StepStatus ""