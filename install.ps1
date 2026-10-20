# 安装 grilling skill 到本机已存在的 Agent Skills 目录。
# 用法：powershell -ExecutionPolicy Bypass -File install.ps1
$ErrorActionPreference = "Stop"

$src = Join-Path $PSScriptRoot "skills\grilling\SKILL.md"
if (-not (Test-Path $src)) {
    Write-Error "找不到 $src —— 请在仓库根目录运行本脚本。"
    exit 1
}

$targets = @()
foreach ($dir in @((Join-Path $HOME ".claude\skills"), (Join-Path $HOME ".workbuddy\skills"))) {
    if (Test-Path $dir) { $targets += $dir }
}

if ($targets.Count -eq 0) {
    $fallback = Join-Path $HOME ".claude\skills"
    New-Item -ItemType Directory -Force -Path $fallback | Out-Null
    $targets += $fallback
}

foreach ($target in $targets) {
    $dest = Join-Path $target "grilling"
    New-Item -ItemType Directory -Force -Path $dest | Out-Null
    Copy-Item -Path $src -Destination (Join-Path $dest "SKILL.md") -Force
    Write-Host "已安装：$dest\SKILL.md"
}

Write-Host ""
Write-Host "完成。重启会话后生效，试试对 AI 说「拷问我」。"
