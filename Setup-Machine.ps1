Param
(
    [Switch]
    $prepOS,

    [Switch]
    $tools,

    [Switch]
    $userTools,

    [Switch]
    $ittools,

    [Switch]
    $dev,

    [Switch]
    $nohyperv,

    [Switch]
    $data,

    [Switch]
    $dataSrv,

    [Switch]
    $installVs,

    [Parameter(Mandatory=$False)]
    [ValidateSet("2017")]
    $vsVersion = "2017",

    [Parameter(Mandatory=$False)]
    [ValidateSet("Community", "Professional", "Enterprise")]
    $vsEdition = "Community",

    [Switch]
    $vsext,

    [Switch]
    $vscodeext,

    [Parameter(Mandatory=$False)]
    [ValidateSet("none", "intelliJ", "eclipse-sts", "all")]
    $installOtherIDE = "none",

    [Switch]
    $cloneRepos,

    [Parameter(Mandatory=$False)]
    $codeBaseDir = "C:\Code"
)



#
# Simple Parameter validation
#
if( $prepOS -and ($tools -or $ittools -or $userTools -or $dev -or $data -or $dataSrv -or $installOtherIDE -or $installVs -or $cloneRepos -or $vsext) ) {
    throw "Running the script with -prepOS does not allow you to use any other switches. First run -prepOS and then run with any other allowed combination of switches!"
}

if( $dev -and $installVs )
{
    throw "Visual Studio and developer tools need to be installed separately. First run with -installVs and then run with -dev!"
}

#
# [prepOS] Installing Operating System Components as well as chocolatey itself. Needs to happen before ANY other runs!
#
if( $prepOS ) 
{
    Set-ExecutionPolicy unrestricted

    # Enable Console Prompting for PowerShell
    Set-ItemProperty "HKLM:\SOFTWARE\Microsoft\PowerShell\1\ShellIds" -Name "ConsolePrompting" -Value $True

    Invoke-Expression ((new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1'))

    Enable-WindowsOptionalFeature -FeatureName NetFx3 -Online -NoRestart
    Enable-WindowsOptionalFeature -FeatureName WCF-Services45 -Online -NoRestart
    Enable-WindowsOptionalFeature -FeatureName WCF-TCP-PortSharing45 -Online -NoRestart
    Enable-WindowsOptionalFeature -FeatureName NetFx4-AdvSrvs -Online -NoRestart
    Enable-WindowsOptionalFeature -FeatureName NetFx4Extended-ASPNET45 -Online -NoRestart
    Enable-WindowsOptionalFeature -FeatureName Windows-Identity-Foundation -Online -NoRestart
    Enable-WindowsOptionalFeature -FeatureName Microsoft-Windows-Subsystem-Linux -Online -NoRestart

    if( ! $nohyperv ) {
        Enable-WindowsOptionalFeature -FeatureName Microsoft-Hyper-V-All -Online -NoRestart
        Enable-WindowsOptionalFeature -FeatureName Containers -Online -NoRestart
    }

    Write-Information ""
    Write-Information "Installation of OS components completed, please restart your computer once ready!"
    Write-Information ""

    Exit
}

#
# Function for refreshing environment variables
#
function RefreshEnvironment() {
    foreach($envLevel in "Machine","User") {
        [Environment]::GetEnvironmentVariables($envLevel).GetEnumerator() | ForEach-Object {
            # For Path variables, append the new values, if they're not already in there
            if($_.Name -match 'Path$') { 
               $_.Value = ($((Get-Content "Env:$($_.Name)") + ";$($_.Value)") -Split ';' | Select-Object -Unique) -Join ';'
            }
            $_
         } | Set-Content -Path { "Env:$($_.Name)" }
    }
}

#
# Function to create a path if it does not exist
#
function CreatePathIfNotExists($pathName) {
    if(!(Test-Path -Path $pathName)) {
        New-Item -ItemType directory -Path $pathName
    }
}

#
# Function to install VSIX extensions
#
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

if( $tools ) {
    cinst -y 7zip
    cinst -y adobereader
    cinst -y googlechrome
    cinst -y jre8
    cinst -y slack
    cinst -y --ignorechecksum goodsync    
    cinst -y conemu 
    cinst -y mousewithoutborders
    cinst -y vim 
    cinst -y curl
    cinst -y --allowemptychecksum winmerge 
    cinst -y wireshark 
    cinst -y sysinternals
    cinst -y --allowemptychecksum jq
    cinst -y --allowemptychecksum OpenSSL.Light
    cinst -y --allowemptychecksum royalts
}

if($installVs) {
    if($vsVersion -eq "2017") {
        switch ($vsEdition) {
            "Community" {
                cinst visualstudio2017community -y --package-parameters "--allWorkloads --includeRecommended --includeOptional --passive --locale en-US"
            }
            "Professional" {
                cinst visualstudio2017professional -y --package-parameters "--allWorkloads --includeRecommended --includeOptional --passive --locale en-US"
            }            
            "Enterprise" {
                cinst visualstudio2017enterprise -y --package-parameters "--allWorkloads --includeRecommended --includeOptional --passive --locale en-US"
            }
        }
    }
}

if( $dev )
{
    cinst -y visualstudiocode
    cinst -y golang
    cinst -y jdk8
    cinst -y nodejs.install
    cinst -y python 
    cinst -y php 
    cinst -y --allowemptychecksum webpi 
    cinst -y git.install
    cinst -y --allowemptychecksum gitextensions
    cinst -y poshgit 
    cinst -y --allowemptychecksum windbg 
    cinst -y fiddler4
    cinst -y postman
    cinst -y nimbletext
    cinst -y --allowemptychecksum ilspy 
    cinst -y --allowemptychecksum linqpad4
    cinst -y docker-for-windows
    cinst -y cloudfoundry-cli
    cinst -y kubernetes-cli
    cinst -y vagrant
    cinst -y nuget.commandline
    cinst -y ngrok.portable

    RefreshEnvironment 

    npm install -g moment
    npm install -g bower
    npm install -g gulp
    pip install azure
    pip install --user azure-cli

    Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force
    Install-Module -Name AzureRM -Force -SkipPublisherCheck 

#    Invoke-WebRequest 'https://howtowhale.github.io/dvm/downloads/latest/install.ps1' -UseBasicParsing | Invoke-Expression
}

if( $data )
{
    cinst -y sql-server-management-studio
    cinst -y --allowemptychecksum dbeaver 
    cinst -y studio3t
    cinst -y --allowemptychecksum SQLite 
    cinst -y --allowemptychecksum sqlite.shell 
}

if( $dataSrv ) {
    
    cinst sql-server-express -version 13.0.1601.5
    #cinst -y mysql 
    #cinst -y mongodb
    #cinst -y datastax.community
    #cinst -y neo4j-community -version 2.2.2.20150617
}


#
# Visual Studio Extensions
#

if( $vsext -and ($vsVersion -eq "2017") ) {

    RefreshEnvironment

    # Productivity Power Tools
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


#
# Visual Studio Code Extensions
#
if ( $vscodeext ) {

    # Refreshing the environment path variables
    RefreshEnvironment

    # Start installing all extensions

    code --install-extension DavidAnson.vscode-markdownlint
    code --install-extension DotJoshJohnson.xml
    code --install-extension eg2.tslint
    code --install-extension eg2.vscode-npm-script
    code --install-extension johnpapa.Angular1
    code --install-extension johnpapa.Angular2
    code --install-extension Angular.ng-template
    code --install-extension lukehoban.Go
    code --install-extension mohsen1.prettify-json
    code --install-extension ms-vscode.cpptools
    code --install-extension ms-vscode.csharp
    code --install-extension ms-vscode.mono-debug   
    code --install-extension ms-vscode.PowerShell
    code --install-extension ms-vscode.node-debug
    code --install-extension vscjava.vscode-java-debug
    code --install-extension ms-vscode.Theme-MarkdownKit    
    code --install-extension ms-vscode.Theme-MaterialKit
    code --install-extension msjsdiag.debugger-for-chrome
    code --install-extension msjsdiag.debugger-for-edge
   
    code --install-extension ms-vscode.vscode-azureextensionpack
}


#
# cloneRepos, cloning all my most important Git repositories
#
if( $cloneRepos ) {

    # Refreshing the environment path variables
    RefreshEnvironment

    #
    # Creating my code directories
    #    
    CreatePathIfNotExists -pathName "$codeBaseDir"
    CreatePathIfNotExists -pathName "$codeBaseDir\github"
    CreatePathIfNotExists -pathName "$codeBaseDir\johnmiller"

    #
    # Github clone repositories 
    #
    CreatePathIfNotExists -pathName "$codeBaseDir\github\mszcool"
    
}