# Creator OS — Codex 启动脚本
# 用法：右键 → 使用 PowerShell 运行，或在终端中执行：.\start-codex.ps1

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path

Write-Host ""
Write-Host "  🧠 Creator OS — 启动 Codex" -ForegroundColor Cyan
Write-Host "  项目目录：$scriptDir" -ForegroundColor Gray
Write-Host ""

# 数据保存在项目内的 data 目录（兼容 Codex 沙盒的 workspace-write 模式）
$env:CREATOR_OS_DATA_DIR = Join-Path $scriptDir "data"

Write-Host "  📁 数据目录：$env:CREATOR_OS_DATA_DIR" -ForegroundColor Gray
Write-Host "  🔓 模式：workspace-write" -ForegroundColor Gray
Write-Host ""

# 搜索 codex 路径
$codexPath = $null
$binDir = Join-Path $env:LOCALAPPDATA "OpenAI\Codex\bin"
if (Test-Path $binDir) {
    $found = Get-ChildItem $binDir -Filter "codex.exe" -Recurse | Select-Object -First 1
    if ($found) { $codexPath = $found.FullName }
}

if (-not $codexPath) {
    $inPath = Get-Command codex -ErrorAction SilentlyContinue
    if ($inPath) { $codexPath = $inPath.Source }
}

if (-not $codexPath) {
    Write-Host "  ❌ 未找到 Codex CLI" -ForegroundColor Red
    Write-Host "  请确认已安装 Codex CLI" -ForegroundColor Yellow
    Read-Host "按 Enter 退出"
    exit 1
}

Write-Host "  ✅ Codex：$codexPath" -ForegroundColor Green
Write-Host ""

& $codexPath -s workspace-write -a on-request -C $scriptDir
