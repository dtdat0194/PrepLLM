@echo off
setlocal enabledelayedexpansion

REM SAT Practice App - Windows Startup Script
REM This script sets up and starts the entire SAT practice platform

echo Starting SAT Practice App...
echo.

REM Colors for output
set "RED=[91m"
set "GREEN=[92m"
set "YELLOW=[93m"
set "BLUE=[94m"
set "NC=[0m"

REM Function to print colored output
call :print_success "Checking prerequisites..."

REM Check if Node.js is installed
node --version >nul 2>&1
if %errorlevel% neq 0 (
    echo %RED%Node.js is not installed. Please install Node.js first.%NC%
    echo Download from: https://nodejs.org/
    pause
    exit /b 1
)

echo %GREEN%Node.js is installed%NC%

REM Check if npm is installed
npm --version >nul 2>&1
if %errorlevel% neq 0 (
    echo %RED%npm is not installed. Please install npm first.%NC%
    pause
    exit /b 1
)

echo %GREEN%npm is installed%NC%

REM Check if backend directory exists
if not exist "backend" (
    echo %RED%Backend directory not found. Please run setup.sh first.%NC%
    pause
    exit /b 1
)

REM Check if frontend directory exists
if not exist "frontend" (
    echo %RED%Frontend directory not found. Please run setup.sh first.%NC%
    pause
    exit /b 1
)

REM Check if backend dependencies are installed
if not exist "backend\node_modules" (
    echo %YELLOW%Backend dependencies not installed. Installing now...%NC%
    cd backend
    call npm install
    cd ..
)

REM Check if frontend dependencies are installed
if not exist "frontend\node_modules" (
    echo %YELLOW%Frontend dependencies not installed. Installing now...%NC%
    cd frontend
    call npm install
    cd ..
)

REM Check if .env file exists in backend
if not exist "backend\.env" (
    echo %YELLOW%Backend .env file not found. Creating default configuration...%NC%
    cd backend
    echo DATABASE_URL="file:./dev.db" > .env
    echo PORT=5001 >> .env
    cd ..
)

REM Check if .env file exists in frontend
if not exist "frontend\.env" (
    echo %YELLOW%Frontend .env file not found. Creating default configuration...%NC%
    cd frontend
    echo REACT_APP_API_URL=http://localhost:5001/api > .env
    cd ..
)

REM Generate Prisma client if needed
cd backend
if not exist "node_modules\.prisma" (
    echo %BLUE%Generating Prisma client...%NC%
    call npx prisma generate
)

REM Check if database exists, if not create it
if not exist "dev.db" (
    echo %BLUE%Creating SQLite database...%NC%
    call npx prisma db push
)

cd ..

REM Kill any existing processes
echo %BLUE%Stopping any existing processes...%NC%
taskkill /f /im node.exe >nul 2>&1
taskkill /f /im npm.exe >nul 2>&1

REM Start backend server
echo %BLUE%Starting backend server...%NC%
cd backend
start /b cmd /c "npm start"
set BACKEND_PID=%errorlevel%
cd ..

REM Wait a moment for backend to start
timeout /t 3 /nobreak >nul

REM Check if backend is running
curl -s http://localhost:5001/api/health >nul 2>&1
if %errorlevel% neq 0 (
    echo %YELLOW%Backend might still be starting up...%NC%
    timeout /t 3 /nobreak >nul
)

REM Start frontend server
echo %BLUE%Starting frontend server...%NC%
cd frontend
start /b cmd /c "npm start"
set FRONTEND_PID=%errorlevel%
cd ..

REM Wait for servers to start
timeout /t 5 /nobreak >nul

REM Check if servers are running
curl -s http://localhost:5001/api/health >nul 2>&1
if %errorlevel% equ 0 (
    echo %GREEN%Backend server is running on http://localhost:5001%NC%
) else (
    echo %RED%Backend server failed to start%NC%
)

curl -s http://localhost:3000 >nul 2>&1
if %errorlevel% equ 0 (
    echo %GREEN%Frontend server is running on http://localhost:3000%NC%
) else (
    echo %YELLOW%Frontend server might still be starting up...%NC%
)

echo.
echo SAT Practice App is starting up!
echo.
echo Server Status:
echo    Backend:  http://localhost:5001
echo    Frontend: http://localhost:3000
echo    Database: SQLite (dev.db)
echo.
echo Next steps:
echo    1. Wait for both servers to fully start
echo    2. Open http://localhost:3000 in your browser
echo    3. If you need to seed the database, run: cd backend ^&^& npm run db:seed
echo.
echo Press Ctrl+C to stop all servers
echo.

REM Keep the script running
pause >nul

REM Cleanup function
:cleanup
echo %BLUE%Shutting down servers...%NC%
taskkill /f /im node.exe >nul 2>&1
taskkill /f /im npm.exe >nul 2>&1
echo %GREEN%All servers stopped%NC%
echo.
echo Note: SQLite database file (dev.db) remains intact
echo    To completely reset, delete backend/dev.db and run setup again
exit /b 0

:print_success
echo %GREEN%~1%NC%
goto :eof 