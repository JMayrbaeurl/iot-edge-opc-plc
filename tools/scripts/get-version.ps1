<#
 .SYNOPSIS
    Sets CI version build variables and/or returns version information.

 .DESCRIPTION
    The script is a wrapper around any versioning tool we use and abstracts it from
    the rest of the build system.
#>

try {
    # Try install tool
    Write-Host "install nbgv"
    try {
        & dotnet @("tool", "install", "-g", "nbgv") 2>&1 | Out-Null    
    }
    catch {
        Write-Error "Cannot install nbgv. Already installed?"
    }
    Write-Host "install nbgv done"

    $props = (& nbgv  @("get-version", "-f", "json")) | ConvertFrom-Json
    if ($LastExitCode -ne 0) {
        throw "Error: 'nbgv get-version -f json' failed with $($LastExitCode)."
    }
    Write-Host "get-version nbgv done"

    return [pscustomobject] @{ 
        Full = $props.CloudBuildAllVars.NBGV_NuGetPackageVersion
        Prefix = $props.CloudBuildAllVars.NBGV_SimpleVersion
    }
}
catch {
    Write-Warning $_.Exception
    return $null
}
