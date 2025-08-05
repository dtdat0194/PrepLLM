# SAT Practice App - Windows Setup Guide

A comprehensive guide to set up and run the SAT Practice App on Windows. This app uses React, Node.js, Express, and SQLite for a complete SAT practice experience.

## Quick Start

### Option 1: One-Command Setup (Recommended)
```cmd
# Navigate to the project directory
cd sat-practice-app

# Run the complete setup and start script
start.bat
```

This will automatically:
- Check prerequisites (Node.js, npm)
- Install dependencies for both backend and frontend
- Set up SQLite database
- Start both servers
- Open the application in your browser

### Option 2: Step-by-Step Setup
```cmd
# 1. Check and install prerequisites
install-prerequisites.bat

# 2. Start the application
start.bat
```

## Prerequisites

### Required Software

1. **Node.js** (v14 or higher)
   - Download from: https://nodejs.org/
   - Choose the LTS version
   - **Important**: Check "Add to PATH" during installation

2. **Git** (for cloning)
   - Download from: https://git-scm.com/
   - Use default settings during installation

### Verification

After installation, verify everything is working:
```cmd
# Check Node.js
node --version

# Check npm
npm --version

# Check Git
git --version
```

## Installation Steps

### Step 1: Clone the Repository
```cmd
# Clone the repository
git clone https://github.com/your-username/sat-practice-app.git
cd sat-practice-app
```

### Step 2: Run the Setup
```cmd
# Run the automated setup
start.bat
```

### Step 3: Access the Application
- **Frontend**: http://localhost:3000
- **Backend API**: http://localhost:5001
- **Database**: SQLite file (backend/dev.db)

## Database Information

This app uses **SQLite**, which provides several advantages:

### Benefits of SQLite
- **No server installation** - Database is just a file
- **Zero configuration** - Works out of the box
- **Easy backup** - Just copy the database file
- **Portable** - Database file can be moved anywhere
- **No dependencies** - No database server required

### Database File Location
- **Path**: `backend/dev.db`
- **Size**: ~50-100MB (depending on question count)
- **Backup**: Simply copy `dev.db` to backup location

## Project Structure

```
sat-practice-app/
├── backend/                 # Node.js/Express API
│   ├── src/
│   │   ├── controllers/    # API controllers
│   │   ├── routes/         # API routes
│   │   ├── models/         # Database models
│   │   └── app.js         # Main server file
│   ├── prisma/
│   │   └── schema.prisma  # Database schema
│   └── dev.db             # SQLite database file
├── frontend/               # React application
│   ├── src/
│   │   ├── components/    # React components
│   │   ├── pages/         # Page components
│   │   └── api/           # API client
│   └── public/            # Static assets
├── windows-setup/          # Windows setup scripts
│   ├── start.bat          # Main startup script
│   ├── install-prerequisites.bat
│   └── troubleshoot.bat
└── README.md              # Main documentation
```

## Configuration

### Environment Variables

The setup scripts will automatically create these files:

**Backend (.env)**
```env
DATABASE_URL="file:./dev.db"
PORT=5001
```

**Frontend (.env)**
```env
REACT_APP_API_URL=http://localhost:5001/api
```

## Usage

### Starting the Application
```cmd
# From the sat-practice-app directory
start.bat
```

### Stopping the Application
- Press `Ctrl+C` in the terminal
- Or close the terminal window

### Database Operations
```cmd
# Seed the database with questions
cd backend
npm run db:seed

# Reset the database
cd backend
del dev.db
npx prisma db push
npm run db:seed
```

## Troubleshooting

### Common Issues and Solutions

#### 1. **"Node.js is not recognized"**
**Problem**: Node.js is not in your PATH
**Solution**:
1. Reinstall Node.js from https://nodejs.org/
2. Make sure to check "Add to PATH" during installation
3. Restart your computer
4. Open a new Command Prompt and try again

#### 2. **"npm is not recognized"**
**Problem**: npm is not in your PATH
**Solution**:
1. Node.js installation includes npm
2. Restart your computer after Node.js installation
3. Open a new Command Prompt

#### 3. **Port already in use**
**Problem**: Ports 3000 or 5001 are already in use
**Solution**:
```cmd
# Check what's using the ports
netstat -ano | findstr :3000
netstat -ano | findstr :5001

# Kill the processes (replace PID with actual process ID)
taskkill /PID <PID> /F
```

#### 4. **Database connection failed**
**Problem**: SQLite database issues
**Solution**:
```cmd
cd backend
del dev.db
npx prisma db push
npm run db:seed
```

#### 5. **Permission denied**
**Problem**: Windows security blocking the application
**Solution**:
1. Run Command Prompt as Administrator
2. Or add the folder to Windows Defender exclusions

### Automated Troubleshooting

Run the diagnostic script:
```cmd
troubleshoot.bat
```

This will:
- Check all prerequisites
- Show system status
- Identify common issues
- Provide solutions

### Manual Diagnostics

#### Check Node.js Installation
```cmd
node --version
npm --version
```

#### Check Port Usage
```cmd
netstat -ano | findstr :3000
netstat -ano | findstr :5001
```

#### Check Database
```cmd
cd backend
dir dev.db
```

#### Check Logs
- Backend logs appear in the terminal
- Frontend logs appear in the browser console (F12)

## API Endpoints

- `GET /api/health` - Health check
- `GET /api/questions` - Get questions with filters
- `GET /api/questions/:id` - Get single question
- `GET /api/questions/questionId/:questionId` - Get by question ID
- `GET /api/questions/filters` - Get available filters

## Development

### Backend Development
```cmd
cd backend
npm run dev          # Start with nodemon (auto-restart)
npm run db:generate  # Generate Prisma client
npm run db:push      # Push schema changes
npm run db:seed      # Seed database with questions
```

### Frontend Development
```cmd
cd frontend
npm start            # Start development server
npm run build        # Build for production
```

## Deployment

### Local Development
```cmd
start.bat    # Start both servers
# Press Ctrl+C to stop
```

### Production Build
```cmd
# Build frontend
cd frontend
npm run build

# Start backend
cd backend
npm start
```

## Performance Tips

### For Better Performance
1. **Close unnecessary applications** - Free up system resources
2. **Use SSD storage** - Faster database access
3. **Adequate RAM** - At least 4GB recommended
4. **Stable internet** - For initial setup and dependencies

### Database Optimization
- SQLite is already optimized for this use case
- Database file is automatically created and managed
- No additional optimization needed

## Getting Help

### Before Asking for Help
1. Run `troubleshoot.bat`
2. Check this documentation
3. Try restarting your computer
4. Verify all prerequisites are installed

### Common Solutions
- **Restart your computer** - Often fixes PATH issues
- **Run as Administrator** - For permission issues
- **Check Windows Defender** - May block Node.js
- **Update Node.js** - Use the latest LTS version

## Success Indicators

When everything is working correctly, you should see:

### Terminal Output
```
Backend server is running on http://localhost:5001
Frontend server is running on http://localhost:3000
SAT Practice App is starting up!
```

### Browser Access
- **Frontend**: http://localhost:3000 loads successfully
- **Questions**: You can browse and filter questions
- **Navigation**: Previous/Next buttons work
- **Filters**: All filter options are functional

## Support

If you're still having issues:

1. **Run diagnostics**: `troubleshoot.bat`
2. **Check logs**: Look at terminal output
3. **Browser console**: Press F12 and check for errors
4. **System requirements**: Ensure you meet the prerequisites

---

**Happy SAT Practice!** 