
@echo off
setlocal EnableExtensions EnableDelayedExpansion
title LocalMind

cd /d "%~dp0"

set "RUNTIME_DIR=runtime\windows"
set "MODEL_DIR=models"
set "RUNTIME="

echo.
echo =================================
echo             LocalMind
echo =================================
echo.

REM Find the first runtime containing "llama" in its filename
for %%F in ("%RUNTIME_DIR%\*llama*.exe") do (
    if exist "%%~fF" (
        set "RUNTIME=%%~fF"
        goto RUNTIME_FOUND
    )
)

echo ERROR: No llama runtime found in %RUNTIME_DIR%
pause
exit /b 1

:RUNTIME_FOUND

REM Scan for GGUF models
set /a COUNT=0

for %%F in ("%MODEL_DIR%\*.gguf") do (
    if exist "%%~fF" (
        set /a COUNT+=1
        set "MODEL[!COUNT!]=%%~fF"
        set "NAME[!COUNT!]=%%~nxF"
    )
)

if !COUNT! EQU 0 (
    echo ERROR: No GGUF models found in %MODEL_DIR%
    pause
    exit /b 1
)

echo Runtime: !RUNTIME!
echo.
echo Available models:
echo.

for /l %%I in (1,1,!COUNT!) do (
    echo [%%I] !NAME[%%I]!
)

echo.
set /p "CHOICE=Select a model: "

REM Validate selection
set "MODEL="

if not "!CHOICE!"=="" (
    for /l %%I in (1,1,!COUNT!) do (
        if "!CHOICE!"=="%%I" set "MODEL=!MODEL[%%I]!"
    )
)

if not defined MODEL (
    echo.
    echo ERROR: Invalid selection.
    pause
    exit /b 1
)

echo.
echo Selected model: !NAME[%CHOICE%]!
echo Starting LocalMind...
echo.

"!RUNTIME!" ^
    --server ^
    --host 127.0.0.1 ^
    --port 8080 ^
    --gpu auto ^
    -m "!MODEL!" ^
    -ngl 999

pause
