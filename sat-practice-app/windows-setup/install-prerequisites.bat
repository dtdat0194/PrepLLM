@echo off
echo ========================================
echo SAT Practice Platform - Prerequisites
echo ========================================
echo.

echo This script will help you install the required software for the SAT Practice Platform.
echo.

echo Checking current installations...
echo.

REM Check Node.js
echo Checking Node.js...
node --version >nul 2>&1
if errorlevel 1 (
    echo [MISSING] Node.js is not installed.
    echo.
    echo Please install Node.js:
    echo 1. Go to https://nodejs.org/
    echo 2. Download the LTS version
    echo 3. Run the installer
    echo 4. Make sure to check "Add to PATH" during installation
    echo.
    pause
) else (
    echo [FOUND] Node.js is installed.
    node --version
)

echo.

REM Check npm
echo Checking npm...
npm --version >nul 2>&1
if errorlevel 1 (
    echo [MISSING] npm is not installed.
    echo Please install Node.js (npm comes with it).
) else (
    echo [FOUND] npm is installed.
    npm --version
)

echo.

REM Check PostgreSQL
echo Checking PostgreSQL...
psql --version >nul 2>&1
if errorlevel 1 (
    echo [MISSING] PostgreSQL is not installed.
    echo.
    echo Please install PostgreSQL:
    echo 1. Go to https://www.postgresql.org/download/windows/
    echo 2. Download the latest version
    echo 3. Run the installer
    echo 4. Remember the password you set for the postgres user
    echo 5. Make sure to add PostgreSQL to your PATH
    echo.
    pause
) else (
    echo [FOUND] PostgreSQL is installed.
    psql --version
)

echo.

REM Check Git
echo Checking Git...
git --version >nul 2>&1
if errorlevel 1 (
    echo [MISSING] Git is not installed.
    echo.
    echo Please install Git:
    echo 1. Go to https://git-scm.com/download/win
    echo 2. Download and run the installer
    echo 3. Use default settings
    echo.
    pause
) else (
    echo [FOUND] Git is installed.
    git --version
)

echo.
echo ========================================
echo Prerequisites Check Complete
echo ========================================
echo.

echo If all items show [FOUND], you're ready to run the platform!
echo If any show [MISSING], please install them first.
echo.

echo To start the platform after installing prerequisites:
echo 1. Clone the repository: git clone https://github.com/dtdat0194/PrepLLM.git
echo 2. Navigate to the folder: cd PrepLLM
echo 3. Run the startup script: start.bat
echo.

pause 