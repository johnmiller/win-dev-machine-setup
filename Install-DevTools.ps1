choco feature enable -n allowGlobalConfirmation
cinst -y 7zip
cinst -y adobereader
cinst -y googlechrome
cinst -y jre8
cinst -y slack
cinst -y --ignorechecksum goodsync    
cinst -y conemu 
cinst -y vim 
cinst -y curl
cinst -y --allowemptychecksum winmerge 
cinst -y wireshark 
cinst -y sysinternals
cinst -y --allowemptychecksum jq
cinst -y --allowemptychecksum OpenSSL.Light
cinst -y --allowemptychecksum royalts-v5
cinst -y evernote
cinst -y evernote-chrome
cinst -y autohotkey
cinst -y visualstudiocode
cinst -y golang
cinst -y jdk8
cinst -y nodejs.install
cinst -y python 
cinst -y php 
cinst -y --allowemptychecksum webpi 
cinst -y kdiff3
cinst -y git.install
cinst -y --allowemptychecksum gitextensions
cinst -y poshgit 
cinst -y --allowemptychecksum windbg 
cinst -y fiddler4
cinst -y postman
cinst -y nimbletext
cinst -y --allowemptychecksum ilspy 
cinst -y --allowemptychecksum linqpad5
cinst -y docker-for-windows
cinst -y cloudfoundry-cli
cinst -y kubernetes-cli
cinst -y kubernetes-helm
cinst -y nuget.commandline
cinst -y ngrok.portable
cinst -y ruby -version 2.2.3 -pin --x86 -y
cinst -y ruby2.devkit --x86 -y
cinst -y jetbrainstoolbox
cinst -y wkhtmltopdf
cinst -y sql-server-express -version 13.0.1601.5
cinst -y sql-server-management-studio
cinst -y sourcetree
cinst -y exiftool

. $PSScriptRoot\Refresh-EnvironmentVariables

npm install -g moment
npm install -g bower
npm install -g gulp

Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force
Install-Module -Name AzureRM -Force -SkipPublisherCheck 
