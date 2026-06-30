@echo off
chcp 65001 >nul
echo.
echo   🧠 Creator OS — 启动 Codex
echo   项目目录：%~dp0
echo.

:: 数据保存在项目内的 data 目录（兼容 Codex 沙盒的 workspace-write 模式）
set "CREATOR_OS_DATA_DIR=%~dp0data"

set "CODEX_PATH="

:: 搜索 codex 安装路径（在版本号子文件夹中）
for /d %%d in ("%LOCALAPPDATA%\OpenAI\Codex\bin\*") do (
    if exist "%%d\codex.exe" (
        set "CODEX_PATH=%%d\codex.exe"
        goto :found
    )
)

:: 尝试直接路径
if exist "%LOCALAPPDATA%\OpenAI\Codex\bin\codex.exe" (
    set "CODEX_PATH=%LOCALAPPDATA%\OpenAI\Codex\bin\codex.exe"
    goto :found
)

:: 尝试 PATH 中的 codex
where codex >nul 2>&1
if %errorlevel%==0 (
    for /f "delims=" %%i in ('where codex') do set "CODEX_PATH=%%i"
    goto :found
)

echo   ❌ 未找到 Codex CLI
echo   请确认已安装 Codex CLI：https://github.com/openai/codex
echo.
pause
exit /b 1

:found
echo   ✅ Codex：%CODEX_PATH%
echo   📁 数据目录：%CREATOR_OS_DATA_DIR%
echo   🔓 模式：workspace-write（安全模式，允许写入项目目录）
echo.

"%CODEX_PATH%" -s workspace-write -a on-request -C "%~dp0"

if %errorlevel% neq 0 (
    echo.
    echo   ❌ Codex 启动失败，错误码：%errorlevel%
    pause
)
