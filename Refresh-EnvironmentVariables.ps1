Write-Host "Refreshing environment variables"

foreach($envLevel in "Machine","User") {
    [Environment]::GetEnvironmentVariables($envLevel).GetEnumerator() | ForEach-Object {
        # For Path variables, append the new values, if they're not already in there
        if($_.Name -match 'Path$') { 
            $_.Value = ($((Get-Content "Env:$($_.Name)") + ";$($_.Value)") -Split ';' | Select-Object -Unique) -Join ';'
        }
        $_
        } | Set-Content -Path { "Env:$($_.Name)" }
}