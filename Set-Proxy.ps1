Param(
    [Switch]
    $on,

    [Switch]
    $off,

    [Switch]
    $list,

    [Parameter(Mandatory=$False)]
    $proxy
)

function clearEnvVariable( $name ) {
    Write-Host "Clearing environment variable: $name"
    [System.Environment]::SetEnvironmentVariable($name, $null, "User")
    [System.Environment]::SetEnvironmentVariable($name, $null, "Machine")

    if (Test-Path Env:$name)
    {
        Remove-Item -Path Env:$name -ErrorAction SilentlyContinue | Out-Null
    }
}

function clearGemSources() {
    Write-Host "Clearing existing gem sources"
    gem sources --remove https://rubygems.org/
    gem sources --remove http://rubygems.org/
}

if ( $on ) {
    Write-Host "Setting proxy env variables"
    [System.Environment]::SetEnvironmentVariable("http_proxy", $proxy, "Machine")
    [System.Environment]::SetEnvironmentVariable("https_proxy", $proxy, "Machine")
    
    Write-Host "Setting chocolatey proxy"
    choco config set proxy $proxy

    clearGemSources

    Write-Host "Adding gem source with proxy"
    gem source --add http://rubygems.org/ --http-proxy $proxy

    Write-Host "Setting git proxy"
    git config --global http.proxy $proxy
    git config --global https.proxy $proxy

    Write-Host "Setting npm proxy"
    npm config set proxy $proxy
    npm config set https-proxy $proxy

    Write-Host "Setting nuget proxy"
    nuget config -Set HTTP_PROXY=$proxy

    Write-Host "Enabling Artifactory nuget source"
    nuget sources Enable -Name Artifactory

    . $PSScriptRoot\Refresh-EnvironmentVariables
}

if ( $off ) {
    clearEnvVariable("http_proxy")
    clearEnvVariable("https_proxy")

    Write-Host "Removing chocolatey proxy"
    choco config unset proxy

    clearGemSources

    Write-Host "Adding gem source"
    gem sources --add http://rubygems.org
    # need to read: http://guides.rubygems.org/ssl-certificate-update/#installing-using-update-packages

    Write-Host "Removing git proxy"
    git config --global --unset http.proxy
    git config --global --unset https.proxy

    Write-Host "Removing npm proxy"
    npm config delete proxy
    npm config delete https-proxy

    Write-Host "Removing nuget proxy"
    nuget config -Set HTTP_PROXY=

    Write-Host "Disabling Artifactory nuget source"
    nuget sources Disable -Name Artifactory

    . $PSScriptRoot\Refresh-EnvironmentVariables
}

if ( $list ) {
    Write-Host "env http_proxy: $env:http_proxy"
    Write-Host "env https_proxy: $env:https_proxy" 
    Write-Host "chocolatey: $(choco config get proxy --limit-output)"
    Write-Host "gem sources: $(gem source --list)"
    Write-Host "git http.proxy: $(git config --global --get http.proxy)"
    Write-Host "git https.proxy: $(git config --global --get https.proxy)"
    Write-Host "npm proxy: $(npm config get proxy)"
    Write-Host "npm https-proxy: $(npm config get https-proxy)"
    Write-Host "nuget proxy: $(nuget config HTTP_PROXY)"
}