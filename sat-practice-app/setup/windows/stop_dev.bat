@echo off
setlocal enabledelayedexpansion

REM SAT Practice App - Stop Development Servers
REM This script stops all running SAT practice app servers

echo Stopping SAT Practice App Development Servers...
echo.

REM Colors for output
set "GREEN=[92m"
set "BLUE=[94m"
set "NC=[0m"

REM Stop all Node.js and npm processes
echo %BLUE%Stopping all Node.js and npm processes...%NC%
taskkill /f /im node.exe >nul 2>&1
taskkill /f /im npm.exe >nul 2>&1

REM Check if processes were stopped
tasklist /fi "imagename eq node.exe" 2>nul | find /i "node.exe" >nul
if %errorlevel% equ 0 (
    echo %BLUE%Some Node.js processes may still be running...
%NC%
) else (
    echo %GREEN%All Node.js processes stopped%NC%
)

echo.
echo %GREEN%All SAT Practice App servers have been stopped%NC%
echo.
echo Note: SQLite database file (backend/dev.db) remains intact
echo    To restart, run: setup\windows\start_dev.bat
echo.
pause 