
@echo off
title LocalMind

cd /d "%~dp0"

set "RUNTIME=runtime\windows\llamafile.exe"
set "MODEL=models\model.gguf" & REM Replace your model path here

if not exist "%RUNTIME%" (
    echo ERROR: Runtime not found: %RUNTIME%
    pause
    exit /b 1
)

if not exist "%MODEL%" (
    echo ERROR: Model not found: %MODEL%
    pause
    exit /b 1
)

"%RUNTIME%" ^
    --server ^
    --host 127.0.0.1 ^
    --port 8080 ^
    --gpu auto ^
    -m "%MODEL%" ^
    -ngl 999

pause
