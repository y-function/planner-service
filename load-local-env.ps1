$ErrorActionPreference = 'Stop'

$envFile = Join-Path $PSScriptRoot 'local.env'
if (-not (Test-Path -LiteralPath $envFile -PathType Leaf)) {
    throw "Environment file not found: $envFile"
}

foreach ($line in Get-Content -LiteralPath $envFile) {
    $entry = $line.Trim()
    if (-not $entry -or $entry.StartsWith('#')) {
        continue
    }

    $separator = $entry.IndexOf('=')
    if ($separator -lt 1) {
        Write-Error $entry ': Invalid local.env entry. Expected KEY=value.'
        continue
    }

    $name = $entry.Substring(0, $separator).Trim()
    $value = $entry.Substring($separator + 1).Trim()

    if ([string]::IsNullOrWhiteSpace($value)) {
        Write-Error $entry ": A non-empty $name value in local.env will be ignored."
        continue
    }

    [Environment]::SetEnvironmentVariable($name, $value, 'User')
    Set-Item -Path "Env:$name" -Value $value
    Write-Output $name "variable was loaded."
}

Write-Output 'Variables were loaded into the current process and saved for the current Windows user.'
