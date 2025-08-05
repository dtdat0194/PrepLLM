# SAT Practice Platform - Windows Setup Guide

This guide will help you set up the SAT Practice Platform on Windows.

## 🚀 Quick Start (Windows)

### Step 1: Install Prerequisites

#### 1. Install Node.js
- Download from: https://nodejs.org/
- Choose the LTS version (recommended)
- Run the installer and follow the setup wizard
- Verify installation: Open Command Prompt and run `node --version`

#### 2. Install PostgreSQL
- Download from: https://www.postgresql.org/download/windows/
- Run the installer
- **Important**: Remember the password you set for the `postgres` user
- Add PostgreSQL to your PATH during installation
- Verify installation: Open Command Prompt and run `psql --version`

#### 3. Install Git (if not already installed)
- Download from: https://git-scm.com/download/win
- Run the installer with default settings
- Verify installation: Open Command Prompt and run `git --version`

### Step 2: Clone and Run

```cmd
# Clone the repository
git clone https://github.com/dtdat0194/PrepLLM.git
cd PrepLLM

# Run the Windows startup script
start.bat
```

## 📋 Prerequisites Checklist

Before running the platform, ensure you have:

- ✅ **Node.js** (v14 or higher) - [Download](https://nodejs.org/)
- ✅ **PostgreSQL** (running) - [Download](https://www.postgresql.org/download/windows/)
- ✅ **Git** (for cloning) - [Download](https://git-scm.com/download/win)

## 🔧 Manual Setup (Alternative)

If the automatic script doesn't work, follow these manual steps:

### 1. Database Setup

```cmd
# Open Command Prompt as Administrator
# Create the database
createdb -U postgres sat_practice_db
```

### 2. Backend Setup

```cmd
cd backend

# Install dependencies
npm install

# Create environment file
echo DATABASE_URL="postgresql://postgres@localhost:5432/sat_practice_db" > .env
echo PORT=5001 >> .env
echo NODE_ENV=development >> .env

# Generate Prisma client
npm run db:generate

# Push database schema
npm run db:push

# Seed the database
npm run db:seed

# Start the server
npm run dev
```

### 3. Frontend Setup

```cmd
# Open a new Command Prompt
cd frontend

# Install dependencies
npm install

# Start the development server
npm start
```

## 🐛 Common Windows Issues & Solutions

### 1. **"psql is not recognized"**
**Solution**: Add PostgreSQL to your PATH
1. Find your PostgreSQL installation (usually `C:\Program Files\PostgreSQL\[version]\bin`)
2. Add this path to your system's PATH environment variable
3. Restart Command Prompt

### 2. **"node is not recognized"**
**Solution**: 
1. Reinstall Node.js
2. Make sure to check "Add to PATH" during installation
3. Restart Command Prompt

### 3. **Port already in use**
**Solution**: 
```cmd
# Check what's using the port
netstat -ano | findstr :3000
netstat -ano | findstr :5001

# Kill the process (replace PID with the actual process ID)
taskkill /f /pid [PID]
```

### 4. **PostgreSQL connection failed**
**Solution**:
1. Make sure PostgreSQL service is running
2. Check Windows Services: `services.msc`
3. Find "PostgreSQL" service and start it
4. Verify connection: `psql -U postgres -d postgres`

### 5. **Permission denied errors**
**Solution**: Run Command Prompt as Administrator

### 6. **Firewall blocking connections**
**Solution**: Allow Node.js and PostgreSQL through Windows Firewall

## 📁 Windows-Specific Files

- `start.bat` - Windows startup script
- `stop.bat` - Windows shutdown script (created automatically)
- `README-Windows.md` - This Windows setup guide

## 🔍 Troubleshooting Commands

### Check if services are running:
```cmd
# Check Node.js processes
tasklist | findstr node

# Check PostgreSQL
sc query postgresql

# Check ports
netstat -ano | findstr :3000
netstat -ano | findstr :5001
```

### View logs:
```cmd
# Backend logs
type backend.log

# Frontend logs
type frontend.log
```

### Restart services:
```cmd
# Stop all Node.js processes
taskkill /f /im node.exe

# Restart PostgreSQL (run as Administrator)
net stop postgresql
net start postgresql
```

## 🎯 Access the Platform

Once everything is running:
- **Frontend**: http://localhost:3000
- **Backend API**: http://localhost:5001

## 🛑 Stop the Platform

```cmd
# Use the automatic stop script
stop.bat

# Or manually stop processes
taskkill /f /im node.exe
```

## 📞 Getting Help

If you encounter issues:

1. **Check the logs**: `type backend.log` and `type frontend.log`
2. **Verify prerequisites**: Make sure Node.js, PostgreSQL, and Git are installed
3. **Check ports**: Ensure ports 3000 and 5001 are not in use
4. **Restart services**: Stop and restart PostgreSQL if needed
5. **Run as Administrator**: Some operations require admin privileges

## 🎉 Success!

Once the platform is running, you'll see:
- A modern web interface at http://localhost:3000
- SAT questions with math rendering
- Filtering and navigation features
- Detailed explanations for each question

**Happy SAT Practice! 🎓** 