@echo off
echo 🚀 SAT Practice App - Prerequisites Checker
echo ===========================================
echo.

REM Colors for output
set "RED=[91m"
set "GREEN=[92m"
set "YELLOW=[93m"
set "BLUE=[94m"
set "NC=[0m"

echo %BLUE%ℹ️  Checking prerequisites for SAT Practice App...%NC%
echo.

REM Check Node.js
echo Checking Node.js...
node --version >nul 2>&1
if %errorlevel% equ 0 (
    for /f "tokens=3" %%a in ('node --version') do set NODE_VERSION=%%a
    echo %GREEN%[FOUND] Node.js version: !NODE_VERSION!%NC%
) else (
    echo %RED%[MISSING] Node.js is not installed.%NC%
    echo.
    echo Please install Node.js:
    echo 1. Go to https://nodejs.org/
    echo 2. Download the LTS version
    echo 3. Run the installer
    echo 4. Make sure to check "Add to PATH" during installation
    echo 5. Restart your computer after installation
    echo.
)

REM Check npm
echo Checking npm...
npm --version >nul 2>&1
if %errorlevel% equ 0 (
    for /f "tokens=1" %%a in ('npm --version') do set NPM_VERSION=%%a
    echo %GREEN%[FOUND] npm version: !NPM_VERSION!%NC%
) else (
    echo %RED%[MISSING] npm is not installed.%NC%
    echo npm should come with Node.js installation.
    echo Try reinstalling Node.js and restarting your computer.
    echo.
)

REM Check Git
echo Checking Git...
git --version >nul 2>&1
if %errorlevel% equ 0 (
    for /f "tokens=3" %%a in ('git --version') do set GIT_VERSION=%%a
    echo %GREEN%[FOUND] Git version: !GIT_VERSION!%NC%
) else (
    echo %YELLOW%[MISSING] Git is not installed.%NC%
    echo Git is recommended for cloning the repository.
    echo Download from: https://git-scm.com/
    echo.
)

REM Check curl (for health checks)
echo Checking curl...
curl --version >nul 2>&1
if %errorlevel% equ 0 (
    echo %GREEN%[FOUND] curl is available%NC%
) else (
    echo %YELLOW%[MISSING] curl is not available%NC%
    echo curl is used for health checks but is not required.
    echo Windows 10 and later should have curl built-in.
    echo.
)

echo.
echo %BLUE%ℹ️  Summary:%NC%
echo.

REM Summary
node --version >nul 2>&1
if %errorlevel% equ 0 (
    echo %GREEN%✅ Node.js: Ready%NC%
) else (
    echo %RED%❌ Node.js: Missing%NC%
)

npm --version >nul 2>&1
if %errorlevel% equ 0 (
    echo %GREEN%✅ npm: Ready%NC%
) else (
    echo %RED%❌ npm: Missing%NC%
)

git --version >nul 2>&1
if %errorlevel% equ 0 (
    echo %GREEN%✅ Git: Ready%NC%
) else (
    echo %YELLOW%⚠️  Git: Missing (optional)%NC%
)

echo.
echo %BLUE%ℹ️  Database Information:%NC%
echo This app uses SQLite, which requires no additional installation.
echo The database file will be created automatically when you run the app.
echo.

if %errorlevel% equ 0 (
    echo %GREEN%🎉 All required prerequisites are satisfied!%NC%
    echo.
    echo You can now run the application with:
    echo   start.bat
    echo.
) else (
    echo %RED%❌ Some prerequisites are missing.%NC%
    echo.
    echo Please install the missing components and try again.
    echo.
)

echo %BLUE%ℹ️  Next steps:%NC%
echo 1. If all prerequisites are satisfied, run: start.bat
echo 2. If you need to install Node.js, visit: https://nodejs.org/
echo 3. After installation, restart your computer
echo 4. Run this script again to verify installation
echo.

pause 