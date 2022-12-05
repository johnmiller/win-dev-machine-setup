. $PSScriptRoot\HelperLibrary.ps1

Install-WingetPackage -Name 1Password
Install-WingetPackage -Name "Snagit 2023"
Install-WingetPackage -Name "Microsoft PowerToys" -Source msstore
Install-WingetPackage -Name 7zip
Install-WingetPackage -Name "Adobe Acrobat Reader DC" -Source msstore
Install-WingetPackage -Name "Google Chrome"
Install-WingetPackage -Name "OpenWhisperSystems.Signal"
Install-WingetPackage -Name "Slack" -Source msstore
Install-WingetPackage -Name "Zoom"
Install-WingetPackage -Name "Adobe Photoshop Express" -Source msstore
Install-WingetPackage -Name "Ookla.Speedtest"
Install-WingetPackage -Name "Microsoft.Teams"
Install-WingetPackage -Name "Citrix.Workspace"

Write-StepStatus ""
Write-StepStatus "Installation of applications complete."
Write-StepStatus ""