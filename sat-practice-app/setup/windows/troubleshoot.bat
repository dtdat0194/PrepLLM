@echo off
echo 🚀 SAT Practice App - Troubleshooting Tool
echo ==========================================
echo.

REM Colors for output
set "RED=[91m"
set "GREEN=[92m"
set "YELLOW=[93m"
set "BLUE=[94m"
set "NC=[0m"

echo %BLUE%ℹ️  Running diagnostics for SAT Practice App...%NC%
echo.

REM Check Node.js
echo %BLUE%ℹ️  Checking Node.js...%NC%
node --version >nul 2>&1
if %errorlevel% equ 0 (
    for /f "tokens=3" %%a in ('node --version') do set NODE_VERSION=%%a
    echo %GREEN%✅ Node.js version: !NODE_VERSION!%NC%
) else (
    echo %RED%❌ Node.js is not installed or not in PATH%NC%
    echo Solution: Install Node.js from https://nodejs.org/
    echo.
)

REM Check npm
echo %BLUE%ℹ️  Checking npm...%NC%
npm --version >nul 2>&1
if %errorlevel% equ 0 (
    for /f "tokens=1" %%a in ('npm --version') do set NPM_VERSION=%%a
    echo %GREEN%✅ npm version: !NPM_VERSION!%NC%
) else (
    echo %RED%❌ npm is not installed or not in PATH%NC%
    echo Solution: Reinstall Node.js (npm comes with it)
    echo.
)

REM Check if backend directory exists
echo %BLUE%ℹ️  Checking project structure...%NC%
if exist "backend" (
    echo %GREEN%✅ Backend directory found%NC%
) else (
    echo %RED%❌ Backend directory not found%NC%
    echo Solution: Make sure you're in the sat-practice-app directory
    echo.
)

if exist "frontend" (
    echo %GREEN%✅ Frontend directory found%NC%
) else (
    echo %RED%❌ Frontend directory not found%NC%
    echo Solution: Make sure you're in the sat-practice-app directory
    echo.
)

REM Check if .env files exist
echo %BLUE%ℹ️  Checking configuration files...%NC%
if exist "backend\.env" (
    echo %GREEN%✅ Backend .env file found%NC%
) else (
    echo %YELLOW%⚠️  Backend .env file not found%NC%
    echo Solution: Will be created automatically when you run start.bat
    echo.
)

if exist "frontend\.env" (
    echo %GREEN%✅ Frontend .env file found%NC%
) else (
    echo %YELLOW%⚠️  Frontend .env file not found%NC%
    echo Solution: Will be created automatically when you run start.bat
    echo.
)

REM Check database file
echo %BLUE%ℹ️  Checking SQLite database...%NC%
if exist "backend\dev.db" (
    echo %GREEN%✅ SQLite database file found%NC%
    for %%A in ("backend\dev.db") do set DB_SIZE=%%~zA
    echo Database size: !DB_SIZE! bytes
) else (
    echo %YELLOW%⚠️  SQLite database file not found%NC%
    echo Solution: Will be created automatically when you run start.bat
    echo.
)

REM Check port usage
echo %BLUE%ℹ️  Checking port availability...%NC%
netstat -ano | findstr :3000 >nul 2>&1
if %errorlevel% equ 0 (
    echo %RED%❌ Port 3000 is in use%NC%
    for /f "tokens=5" %%a in ('netstat -ano ^| findstr :3000') do (
        echo Process ID: %%a
        tasklist /fi "PID eq %%a" 2>nul
    )
    echo Solution: Close the application using port 3000 or kill the process
    echo.
) else (
    echo %GREEN%✅ Port 3000 is available%NC%
)

netstat -ano | findstr :5001 >nul 2>&1
if %errorlevel% equ 0 (
    echo %RED%❌ Port 5001 is in use%NC%
    for /f "tokens=5" %%a in ('netstat -ano ^| findstr :5001') do (
        echo Process ID: %%a
        tasklist /fi "PID eq %%a" 2>nul
    )
    echo Solution: Close the application using port 5001 or kill the process
    echo.
) else (
    echo %GREEN%✅ Port 5001 is available%NC%
)

REM Check Node.js processes
echo %BLUE%ℹ️  Checking Node.js processes...%NC%
tasklist /fi "IMAGENAME eq node.exe" 2>nul | findstr node.exe >nul
if %errorlevel% equ 0 (
    echo %YELLOW%⚠️  Node.js processes are running%NC%
    tasklist /fi "IMAGENAME eq node.exe"
    echo.
    echo To stop all Node.js processes, run:
    echo   taskkill /f /im node.exe
    echo.
) else (
    echo %GREEN%✅ No Node.js processes running%NC%
)

REM Check if curl is available for health checks
echo %BLUE%ℹ️  Checking curl availability...%NC%
curl --version >nul 2>&1
if %errorlevel% equ 0 (
    echo %GREEN%✅ curl is available for health checks%NC%
) else (
    echo %YELLOW%⚠️  curl is not available%NC%
    echo This is used for health checks but is not required.
    echo Windows 10 and later should have curl built-in.
    echo.
)

REM Test backend if it's running
echo %BLUE%ℹ️  Testing backend connection...%NC%
curl -s http://localhost:5001/api/health >nul 2>&1
if %errorlevel% equ 0 (
    echo %GREEN%✅ Backend is responding%NC%
) else (
    echo %YELLOW%⚠️  Backend is not responding%NC%
    echo This is normal if the backend is not running.
    echo.
)

REM Test frontend if it's running
echo %BLUE%ℹ️  Testing frontend connection...%NC%
curl -s http://localhost:3000 >nul 2>&1
if %errorlevel% equ 0 (
    echo %GREEN%✅ Frontend is responding%NC%
) else (
    echo %YELLOW%⚠️  Frontend is not responding%NC%
    echo This is normal if the frontend is not running.
    echo.
)

echo.
echo %BLUE%ℹ️  Summary and Recommendations:%NC%
echo.

REM Provide recommendations based on findings
node --version >nul 2>&1
if %errorlevel% neq 0 (
    echo %RED%❌ Install Node.js from https://nodejs.org/%NC%
)

npm --version >nul 2>&1
if %errorlevel% neq 0 (
    echo %RED%❌ Reinstall Node.js (npm comes with it)%NC%
)

if not exist "backend" (
    echo %RED%❌ Make sure you're in the sat-practice-app directory%NC%
)

netstat -ano | findstr ":3000\|:5001" >nul 2>&1
if %errorlevel% equ 0 (
    echo %YELLOW%⚠️  Close applications using ports 3000 or 5001%NC%
)

echo.
echo %BLUE%ℹ️  Quick fixes:%NC%
echo 1. If Node.js is missing: Install from https://nodejs.org/
echo 2. If ports are in use: Close other applications or restart computer
echo 3. If database issues: Delete backend/dev.db and run start.bat again
echo 4. If permission issues: Run Command Prompt as Administrator
echo 5. If PATH issues: Restart computer after installing Node.js
echo.

echo %BLUE%ℹ️  Next steps:%NC%
echo 1. Fix any issues listed above
echo 2. Run start.bat to start the application
echo 3. If problems persist, check the browser console (F12)
echo.

pause 