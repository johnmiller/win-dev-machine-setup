Param
(
    [Parameter(Mandatory=$False)]
    [ValidateSet("2017")]
    $vsVersion = "2017",

    [Parameter(Mandatory=$False)]
    [ValidateSet("Community", "Professional", "Enterprise")]
    $vsEdition = "Professional"
)

$vsixInstallerCommand2017 = "C:\Program Files (x86)\Microsoft Visual Studio\2017\$vsEdition\Common7\IDE\VsixInstaller.exe"
$vsixInstallerCommandGeneralArgs = " /q /a "

function InstallVSExtension($extensionUrl, $extensionFileName, $vsVersion) {
    
    Write-Host "Installing extension " $extensionFileName
    
    # Select the appropriate VSIX installer
    if($vsVersion -eq "2017") {
        $vsixInstallerCommand = $vsixInstallerCommand2017
    }

    # Download the extension
    Invoke-WebRequest $extensionUrl -OutFile $extensionFileName

    # Quiet Install of the Extension
    $proc = Start-Process -FilePath "$vsixInstallerCommand" -ArgumentList ($vsixInstallerCommandGeneralArgs + $extensionFileName) -PassThru
    $proc.WaitForExit()
    if ( $proc.ExitCode -ne 0 ) {
        Write-Host "Unable to install extension " $extensionFileName " due to error " $proc.ExitCode -ForegroundColor Red
    }

    # Delete the downloaded extension file from the local system
    Remove-Item $extensionFileName
}

if( $vsVersion -eq "2017" ) {
    .\Refresh-EnvironmentVariables.ps1

    # https://marketplace.visualstudio.com/items?itemName=GitHub.GitHubExtensionforVisualStudio
    InstallVSExtension -extensionUrl "https://visualstudiogallery.msdn.microsoft.com/75be44fb-0794-4391-8865-c3279527e97d/file/159055/36/GitHub.VisualStudio.vsix" `
                       -extensionFileName "GitHubExtensionsForVS.vsix" -vsVersion $vsVersion

    # Snippet Designer
    # https://marketplace.visualstudio.com/items?itemName=vs-publisher-2795.SnippetDesigner
    InstallVSExtension -extensionUrl "https://visualstudiogallery.msdn.microsoft.com/b08b0375-139e-41d7-af9b-faee50f68392/file/5131/16/SnippetDesigner.vsix" `
                       -extensionFileName "SnippetDesigner.vsix" -vsVersion $vsVersion

    # Web Essentials 2017
    # https://marketplace.visualstudio.com/items?itemName=MadsKristensen.WebExtensionPack2017
    InstallVSExtension -extensionUrl "https://visualstudiogallery.msdn.microsoft.com/a5a27916-2099-4c5b-a3ff-6a46e4b01298/file/236262/11/Web%20Essentials%202017%20v1.5.8.vsix" `
                       -extensionFileName "WebEssentials2017.vsix" -vsVersion $vsVersion

    # Productivity Power Tools 2017
    # https://marketplace.visualstudio.com/items?itemName=VisualStudioProductTeam.ProductivityPowerPack2017
    InstallVSExtension -extensionUrl "https://visualstudiogallery.msdn.microsoft.com/11693073-e58a-45b3-8818-b2cf5d925af7/file/244442/4/ProductivityPowerTools2017.vsix" `
                       -extensionFileName "ProductivityPowertools2017.vsix" -vsVersion $vsVersion

    # Power Commands 2017
    # https://marketplace.visualstudio.com/items?itemName=VisualStudioProductTeam.PowerCommandsforVisualStudio
    InstallVSExtension -extensionUrl "https://visualstudiogallery.msdn.microsoft.com/80f73460-89cd-4d93-bccb-f70530943f82/file/242896/4/PowerCommands.vsix" `
                       -extensionFileName "PowerCommands2017.vsix" -vsVersion $vsVersion

    # Power Shell Tools 2017
    # https://marketplace.visualstudio.com/items?itemName=AdamRDriscoll.PowerShellToolsforVisualStudio2017-18561
    InstallVSExtension -extensionUrl "https://visualstudiogallery.msdn.microsoft.com/8389e80d-9e40-4fc1-907c-a07f7842edf2/file/257196/1/PowerShellTools.15.0.vsix" `
                       -extensionFileName "PowerShellTools2017.vsix" -vsVersion $vsVersion

}