$ErrorActionPreference = 'Stop'

$root = Split-Path -Parent $PSScriptRoot
$versionFile = Join-Path $root 'version.txt'
$templateFile = Join-Path $root 'README.template.md'
$outputFile = Join-Path $root 'README.md'

if (-not (Test-Path -LiteralPath $versionFile)) {
    throw "Version file not found: $versionFile"
}

if (-not (Test-Path -LiteralPath $templateFile)) {
    throw "Template file not found: $templateFile"
}

$version = (Get-Content -LiteralPath $versionFile -Raw -Encoding UTF8).Trim()
if ([string]::IsNullOrWhiteSpace($version)) {
    throw "Version file is empty: $versionFile"
}

$template = Get-Content -LiteralPath $templateFile -Raw -Encoding UTF8
if ($template -notmatch '\{\{VERSION\}\}') {
    throw "Template does not contain {{VERSION}} placeholder: $templateFile"
}

$output = $template.Replace('{{VERSION}}', $version)
Set-Content -LiteralPath $outputFile -Value $output -Encoding UTF8

Write-Output "README.md updated to version $version"
