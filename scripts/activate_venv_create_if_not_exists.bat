@echo off
REM Batch file to create or activate a Python virtual environment one level above this script.
REM If .venv does not exist, it will be created, then activated in a new PowerShell window.

REM ----------------- Setup: go to parent directory -----------------
SET "SCRIPT_DIR=%~dp0"
SET "PROJECT_ROOT=%SCRIPT_DIR%\.."
cd /d "%PROJECT_ROOT%"
echo INFO: Working directory set to %CD%
echo.

REM ----------------- Virtual environment check / creation ----------
SET "VENV_DIR=%CD%\.venv"
SET "ACTIVATE_PS=%VENV_DIR%\Scripts\activate.ps1"

IF NOT EXIST "%ACTIVATE_PS%" (
    echo INFO: No virtual environment found. Creating one in "%VENV_DIR%"...
    python -m venv "%VENV_DIR%"
    IF ERRORLEVEL 1 (
        echo ERROR: Python failed to create the virtual environment.
        pause
        goto :eof
    )
    echo INFO: Virtual environment created successfully.
) ELSE (
    echo INFO: Existing virtual environment detected at "%VENV_DIR%".
)
echo.

REM ----------------- Launch PowerShell and activate venv -----------
echo Launching PowerShell and activating virtual environment...
powershell.exe -NoProfile -NoExit -ExecutionPolicy Bypass -Command ^
    "& { $sp = '%ACTIVATE_PS%'; if (Test-Path $sp) { & $sp; $host.ui.rawui.WindowTitle = 'VENV Activated: ' + (Get-Location).Path; Write-Host -ForegroundColor Green 'Virtual environment activated.' } else { Write-Host -ForegroundColor Red ('ERROR: Activation script not found at ' + $sp); Read-Host 'Press Enter to exit' } }"
echo.

REM ----------------- Install dependencies if requirements.txt exists
IF EXIST "requirements.txt" (
    echo INFO: Installing dependencies from requirements.txt...
    "%VENV_DIR%\Scripts\pip" install -r requirements.txt
    IF ERRORLEVEL 1 (
        echo ERROR: Failed to install dependencies.
        pause
        goto :eof
    )
    echo INFO: Dependencies installed successfully.
) ELSE (
    echo WARNING: requirements.txt not found. Skipping dependency installation.
)

:eof
