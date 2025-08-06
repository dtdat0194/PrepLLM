@echo off
setlocal enabledelayedexpansion

REM SAT Practice App - Development Startup Script
REM This script automatically sets up and starts the entire SAT practice platform

echo Starting SAT Practice App Development Environment...
echo.

REM Colors for output
set "RED=[91m"
set "GREEN=[92m"
set "YELLOW=[93m"
set "BLUE=[94m"
set "NC=[0m"

REM Function to print colored output
call :print_success "Initializing development environment..."

REM Change to the sat-practice-app root directory
cd /d "%~dp0..\.."
echo %BLUE%Working directory: %CD%%NC%

REM Activate conda environment first
echo %BLUE%Activating conda environment...%NC%
call conda activate sat_env
if %errorlevel% neq 0 (
    echo %RED%Failed to activate sat_env conda environment.%NC%
    echo Please ensure the sat_env environment exists: conda create -n sat_env python=3.9
    pause
    exit /b 1
)
echo %GREEN%Conda environment sat_env activated successfully%NC%

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
call npm --version >nul 2>&1
if %errorlevel% neq 0 (
    echo %RED%npm is not installed. Please install npm first.%NC%
    pause
    exit /b 1
)

echo %GREEN%npm is installed%NC%

REM Check if conda is available
call conda --version >nul 2>&1
if %errorlevel% equ 0 (
    echo %GREEN%Conda is available%NC%
    set "USE_CONDA=1"
) else (
    echo %YELLOW%Conda not found, using system Python%NC%
    set "USE_CONDA=0"
)

REM Kill any existing processes
echo %BLUE%Stopping any existing processes...%NC%
taskkill /f /im node.exe >nul 2>&1
taskkill /f /im npm.exe >nul 2>&1

REM Install dependencies if needed
echo %BLUE%Checking and installing dependencies...%NC%

REM Install backend dependencies
if not exist "backend\node_modules" (
    echo %YELLOW%Installing backend dependencies...%NC%
    cd backend
    call npm install
    cd ..
)

REM Install frontend dependencies
if not exist "frontend\node_modules" (
    echo %YELLOW%Installing frontend dependencies...%NC%
    cd frontend
    call npm install
    cd ..
)

REM Set up environment files
echo %BLUE%Setting up environment configuration...%NC%

REM Backend .env
if not exist "backend\.env" (
    echo %YELLOW%Creating backend .env file...%NC%
    cd backend
    echo DATABASE_URL=file:./dev.db > .env
    echo PORT=5001 >> .env
    cd ..
)

REM Frontend .env
if not exist "frontend\.env" (
    echo %YELLOW%Creating frontend .env file...%NC%
    cd frontend
    echo REACT_APP_API_URL=http://localhost:5001/api > .env
    cd ..
)

REM Set up database
echo %BLUE%Setting up database...%NC%
cd backend

REM Generate Prisma client
if not exist "node_modules\.prisma" (
    echo %YELLOW%Generating Prisma client...%NC%
    call npx prisma generate
)

REM Create database if it doesn't exist
if not exist "dev.db" (
    echo %YELLOW%Creating SQLite database...%NC%
    call npx prisma db push
)

REM Process and seed questions if needed
if not exist "cleaned_questions_full.json" (
    echo %YELLOW%Processing question data...%NC%
    cd ..
    call python data\convertJSON.py
    copy data\cleaned_questions_full.json cleaned_questions_full.json >nul
    cd backend
) else (
    echo %YELLOW%Copying existing question data...%NC%
    cd ..
    copy data\cleaned_questions_full.json cleaned_questions_full.json >nul
    cd backend
)

REM Seed database if empty
echo %YELLOW%Seeding database with questions...%NC%
call npm run db:seed

cd ..

REM Start backend server
echo %BLUE%Starting backend server...%NC%
cd backend
start "SAT Backend" cmd /c "conda activate sat_env && npm start"
cd ..

REM Wait for backend to start
echo %BLUE%Waiting for backend to start...%NC%
timeout /t 5 /nobreak >nul

REM Check if backend is running
curl -s http://localhost:5001/api/health >nul 2>&1
if %errorlevel% equ 0 (
    echo %GREEN%Backend server is running on http://localhost:5001%NC%
) else (
    echo %YELLOW%Backend server might still be starting up...%NC%
    timeout /t 3 /nobreak >nul
)

REM Start frontend server
echo %BLUE%Starting frontend server...%NC%
cd frontend
start "SAT Frontend" cmd /c "conda activate sat_env && npm start"
cd ..

REM Wait for frontend to start
echo %BLUE%Waiting for frontend to start...%NC%
timeout /t 8 /nobreak >nul

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
echo    Database: SQLite (backend/dev.db)
echo    Prisma Studio: http://localhost:5555 (if needed)
echo.
echo Quick Access:
echo    - Main App: http://localhost:3000
echo    - API Health: http://localhost:5001/api/health
echo    - Database: http://localhost:5555 (run: cd backend ^&^& npx prisma studio)
echo.
echo Development Commands:
echo    - Stop servers: Press Ctrl+C in each terminal window
echo    - Restart backend: cd backend ^&^& npm run dev
echo    - Restart frontend: cd frontend ^&^& npm start
echo    - View database: cd backend ^&^& npx prisma studio
echo.
echo To stop all servers, close the terminal windows or press Ctrl+C
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
echo    To completely reset, delete backend/dev.db and run this script again
exit /b 0

:print_success
echo %GREEN%~1%NC%
goto :eof 