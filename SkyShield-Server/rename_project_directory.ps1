$ErrorActionPreference = "Stop"

$current = $PSScriptRoot
$parent = Split-Path -Parent $current
$targetName = "SkyShield-Vue"
$target = Join-Path $parent $targetName

if (Test-Path -LiteralPath $target) {
    throw "目标目录已存在：$target"
}

Set-Location -LiteralPath $parent
Rename-Item -LiteralPath $current -NewName $targetName
Write-Host "项目目录已重命名为：$target"
