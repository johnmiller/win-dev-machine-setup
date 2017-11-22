Param
(
    [Parameter(Mandatory=$False)]
    [ValidateSet("2017")]
    $vsVersion = "2017",

    [Parameter(Mandatory=$False)]
    [ValidateSet("Community", "Professional", "Enterprise")]
    $vsEdition = "Professional"
)

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

. $PSScriptRoot\Refresh-EnvironmentVariables