@echo off
setlocal enabledelayedexpansion

REM SAT Practice Platform - Windows Startup Script
REM This script sets up and starts the entire SAT practice platform on Windows

echo 🚀 Starting SAT Practice Platform...
echo ==================================

REM Check if we're in the right directory
if not exist "package.json" (
    echo [ERROR] Please run this script from the sat-practice-app directory
    pause
    exit /b 1
)

if not exist "backend" (
    echo [ERROR] Backend directory not found
    pause
    exit /b 1
)

if not exist "frontend" (
    echo [ERROR] Frontend directory not found
    pause
    exit /b 1
)

REM Check prerequisites
echo [INFO] Checking prerequisites...

REM Check Node.js
node --version >nul 2>&1
if errorlevel 1 (
    echo [ERROR] Node.js is not installed. Please install Node.js first.
    echo Download from: https://nodejs.org/
    pause
    exit /b 1
)

REM Check npm
npm --version >nul 2>&1
if errorlevel 1 (
    echo [ERROR] npm is not installed. Please install npm first.
    pause
    exit /b 1
)

REM Check PostgreSQL
psql --version >nul 2>&1
if errorlevel 1 (
    echo [ERROR] PostgreSQL is not installed. Please install PostgreSQL first.
    echo Download from: https://www.postgresql.org/download/windows/
    pause
    exit /b 1
)

echo [SUCCESS] All prerequisites are satisfied!

REM Kill any existing processes
echo [INFO] Stopping any existing processes...
taskkill /f /im node.exe >nul 2>&1
taskkill /f /im npm.exe >nul 2>&1

REM Kill processes on ports 3000 and 5001
for /f "tokens=5" %%a in ('netstat -aon ^| findstr :3000') do taskkill /f /pid %%a >nul 2>&1
for /f "tokens=5" %%a in ('netstat -aon ^| findstr :5001') do taskkill /f /pid %%a >nul 2>&1

echo [SUCCESS] Stopped existing processes

REM Database setup
echo [INFO] Setting up database...

REM Create database if it doesn't exist
psql -U postgres -c "SELECT 1 FROM pg_database WHERE datname='sat_practice_db'" | findstr 1 >nul
if errorlevel 1 (
    echo [INFO] Creating database...
    createdb -U postgres sat_practice_db
    echo [SUCCESS] Database created
) else (
    echo [INFO] Database already exists
)

REM Backend setup
echo [INFO] Setting up backend...

cd backend

REM Install dependencies if node_modules doesn't exist
if not exist "node_modules" (
    echo [INFO] Installing backend dependencies...
    npm install
    echo [SUCCESS] Backend dependencies installed
) else (
    echo [INFO] Backend dependencies already installed
)

REM Create .env file if it doesn't exist
if not exist ".env" (
    echo [INFO] Creating backend environment file...
    (
        echo DATABASE_URL="postgresql://postgres@localhost:5432/sat_practice_db"
        echo PORT=5001
        echo NODE_ENV=development
    ) > .env
    echo [SUCCESS] Environment file created
)

REM Generate Prisma client
echo [INFO] Generating Prisma client...
npm run db:generate

REM Push database schema
echo [INFO] Setting up database schema...
npm run db:push

REM Seed database if it's empty
for /f "tokens=1" %%a in ('psql -U postgres -d sat_practice_db -t -c "SELECT COUNT(*) FROM questions;"') do set QUESTION_COUNT=%%a
if !QUESTION_COUNT!==0 (
    echo [INFO] Seeding database with questions...
    npm run db:seed
    echo [SUCCESS] Database seeded with questions
) else (
    echo [INFO] Database already contains !QUESTION_COUNT! questions
)

REM Start backend server in background
echo [INFO] Starting backend server...
start /b npm run dev > ..\backend.log 2>&1

REM Wait for backend to start
echo [INFO] Waiting for backend to start...
timeout /t 5 /nobreak >nul

REM Test backend
curl -s http://localhost:5001/api/health >nul 2>&1
if errorlevel 1 (
    echo [ERROR] Backend failed to start. Check backend.log for details.
    pause
    exit /b 1
) else (
    echo [SUCCESS] Backend is running on http://localhost:5001
)

cd ..

REM Frontend setup
echo [INFO] Setting up frontend...

cd frontend

REM Install dependencies if node_modules doesn't exist
if not exist "node_modules" (
    echo [INFO] Installing frontend dependencies...
    npm install
    echo [SUCCESS] Frontend dependencies installed
) else (
    echo [INFO] Frontend dependencies already installed
)

REM Start frontend server in background
echo [INFO] Starting frontend server...
start /b npm start > ..\frontend.log 2>&1

cd ..

REM Wait for frontend to start
echo [INFO] Waiting for frontend to start...
timeout /t 10 /nobreak >nul

REM Test frontend
curl -s http://localhost:3000 >nul 2>&1
if errorlevel 1 (
    echo [WARNING] Frontend may still be starting up...
) else (
    echo [SUCCESS] Frontend is running on http://localhost:3000
)

REM Create a stop script
echo @echo off > stop.bat
echo echo 🛑 Stopping SAT Practice Platform... >> stop.bat
echo taskkill /f /im node.exe ^>nul 2^>^&1 >> stop.bat
echo taskkill /f /im npm.exe ^>nul 2^>^&1 >> stop.bat
echo for /f "tokens=5" %%%%a in ^('netstat -aon ^| findstr :3000^'^) do taskkill /f /pid %%%%a ^>nul 2^>^&1 >> stop.bat
echo for /f "tokens=5" %%%%a in ^('netstat -aon ^| findstr :5001^'^) do taskkill /f /pid %%%%a ^>nul 2^>^&1 >> stop.bat
echo echo ✅ All processes stopped >> stop.bat

REM Display final status
echo.
echo 🎉 SAT Practice Platform is now running!
echo ========================================
echo.
echo 📱 Frontend: http://localhost:3000
echo 🔧 Backend API: http://localhost:5001
echo.
echo 📊 Database: PostgreSQL (sat_practice_db)
echo 📝 Questions loaded: !QUESTION_COUNT!
echo.
echo 🛑 To stop the platform, run: stop.bat
echo.
echo 📋 Useful commands:
echo    - View backend logs: type backend.log
echo    - View frontend logs: type frontend.log
echo    - Restart backend: cd backend ^& npm run dev
echo    - Restart frontend: cd frontend ^& npm start
echo.
echo 🔍 Troubleshooting:
echo    - If frontend shows errors, check the browser console (F12)
echo    - If backend fails, check backend.log
echo    - If database issues, run: cd backend ^& npm run db:push
echo.

echo [SUCCESS] Platform is ready! Open http://localhost:3000 in your browser.
echo.
echo Press Ctrl+C to stop all services...

REM Keep the script running
pause 