@echo off
echo ========================================
echo SAT Practice Platform - Troubleshooting
echo ========================================
echo.

echo This script will help diagnose common issues with the SAT Practice Platform.
echo.

echo Checking system status...
echo.

REM Check if Node.js processes are running
echo Checking for Node.js processes...
tasklist | findstr node.exe >nul
if errorlevel 1 (
    echo [INFO] No Node.js processes are currently running.
) else (
    echo [RUNNING] Node.js processes found:
    tasklist | findstr node.exe
)

echo.

REM Check ports
echo Checking if ports are in use...
echo.

echo Checking port 3000 (Frontend)...
netstat -ano | findstr :3000 >nul
if errorlevel 1 (
    echo [FREE] Port 3000 is available.
) else (
    echo [IN USE] Port 3000 is being used by:
    netstat -ano | findstr :3000
)

echo.

echo Checking port 5001 (Backend)...
netstat -ano | findstr :5001 >nul
if errorlevel 1 (
    echo [FREE] Port 5001 is available.
) else (
    echo [IN USE] Port 5001 is being used by:
    netstat -ano | findstr :5001
)

echo.

REM Check PostgreSQL service
echo Checking PostgreSQL service...
sc query postgresql >nul 2>&1
if errorlevel 1 (
    echo [ERROR] PostgreSQL service not found.
) else (
    sc query postgresql | findstr STATE
)

echo.

REM Check if database exists
echo Checking database connection...
psql -U postgres -c "SELECT 1;" >nul 2>&1
if errorlevel 1 (
    echo [ERROR] Cannot connect to PostgreSQL.
    echo Make sure PostgreSQL is running and accessible.
) else (
    echo [SUCCESS] PostgreSQL connection successful.
    
    REM Check if our database exists
    psql -U postgres -c "SELECT 1 FROM pg_database WHERE datname='sat_practice_db';" | findstr 1 >nul
    if errorlevel 1 (
        echo [MISSING] Database 'sat_practice_db' does not exist.
    ) else (
        echo [FOUND] Database 'sat_practice_db' exists.
        
        REM Check question count
        for /f "tokens=1" %%a in ('psql -U postgres -d sat_practice_db -t -c "SELECT COUNT(*) FROM questions;" 2^>nul') do set QUESTION_COUNT=%%a
        if !QUESTION_COUNT!==0 (
            echo [EMPTY] Database has no questions.
        ) else (
            echo [LOADED] Database has !QUESTION_COUNT! questions.
        )
    )
)

echo.

REM Check log files
echo Checking log files...
echo.

if exist "backend.log" (
    echo [FOUND] backend.log exists.
    echo Last 5 lines of backend.log:
    powershell "Get-Content backend.log -Tail 5"
) else (
    echo [MISSING] backend.log not found.
)

echo.

if exist "frontend.log" (
    echo [FOUND] frontend.log exists.
    echo Last 5 lines of frontend.log:
    powershell "Get-Content frontend.log -Tail 5"
) else (
    echo [MISSING] frontend.log not found.
)

echo.

REM Check if curl is available
echo Checking curl availability...
curl --version >nul 2>&1
if errorlevel 1 (
    echo [MISSING] curl is not available. Windows 10+ should have it by default.
) else (
    echo [FOUND] curl is available.
)

echo.

echo ========================================
echo Troubleshooting Complete
echo ========================================
echo.

echo Common solutions:
echo.
echo 1. If ports are in use:
echo    - Kill the processes using: taskkill /f /pid [PID]
echo.
echo 2. If PostgreSQL is not running:
echo    - Start it from Services (services.msc)
echo    - Or run: net start postgresql
echo.
echo 3. If database issues:
echo    - Run: cd backend ^& npm run db:push
echo    - Then: cd backend ^& npm run db:seed
echo.
echo 4. If Node.js issues:
echo    - Kill all Node processes: taskkill /f /im node.exe
echo    - Restart the platform: start.bat
echo.

echo Press any key to exit...
pause >nul 