# Windows Setup for SAT Practice Platform

This folder contains all the necessary files to set up and run the SAT Practice Platform on Windows.

## 📁 Files in this folder:

- **`start.bat`** - Main startup script (equivalent to `start.sh` on Mac/Linux)
- **`README-Windows.md`** - Detailed Windows setup guide
- **`install-prerequisites.bat`** - Script to check and guide installation of prerequisites
- **`troubleshoot.bat`** - Diagnostic script for common Windows issues

## 🚀 Quick Start for Windows Users:

### Step 1: Install Prerequisites
```cmd
# Run the prerequisites checker
install-prerequisites.bat
```

### Step 2: Clone and Run
```cmd
# Clone the repository
git clone https://github.com/dtdat0194/PrepLLM.git
cd PrepLLM

# Copy Windows files to main directory
copy windows-setup\start.bat .
copy windows-setup\install-prerequisites.bat .
copy windows-setup\troubleshoot.bat .

# Run the platform
start.bat
```

## 📋 What each script does:

### `start.bat`
- ✅ Checks prerequisites (Node.js, npm, PostgreSQL)
- ✅ Sets up database and seeds with questions
- ✅ Installs dependencies for both backend and frontend
- ✅ Starts both servers with health checks
- ✅ Creates `stop.bat` for easy shutdown

### `install-prerequisites.bat`
- 🔍 Checks if Node.js, npm, PostgreSQL, and Git are installed
- 📋 Provides download links and installation instructions
- ✅ Verifies installations are working correctly

### `troubleshoot.bat`
- 🔍 Diagnoses common Windows issues
- 📊 Shows system status (ports, processes, database)
- 📝 Displays recent log entries
- 💡 Provides solutions for common problems

## 🎯 Access the Platform:

Once running:
- **Frontend**: http://localhost:3000
- **Backend API**: http://localhost:5001

## 🛑 Stop the Platform:

```cmd
stop.bat
```

## 🐛 If you have issues:

1. **Run the troubleshooter**: `troubleshoot.bat`
2. **Check the detailed guide**: `README-Windows.md`
3. **Verify prerequisites**: `install-prerequisites.bat`

## 📞 Common Windows Issues:

- **"psql is not recognized"** → Add PostgreSQL to PATH
- **"node is not recognized"** → Reinstall Node.js with PATH option
- **Port conflicts** → Use `troubleshoot.bat` to identify and kill processes
- **Permission errors** → Run Command Prompt as Administrator

## 🎉 Success!

Once everything is working, you'll have:
- ✅ Complete SAT practice platform
- ✅ Math equation rendering
- ✅ Question filtering and navigation
- ✅ Detailed explanations
- ✅ Modern responsive interface

**Happy SAT Practice! 🎓** 