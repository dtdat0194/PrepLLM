# SAT Practice App - Development Setup

This document explains how to use the automated development setup scripts for the SAT Practice App.

## Quick Start

### One-Command Setup and Start
```cmd
# Navigate to the project directory
cd sat-practice-app

# Run the automated development startup script
setup\windows\start_dev.bat
```

This single command will:
- Check all prerequisites (Node.js, npm, conda)
- Install all dependencies for backend and frontend
- Set up environment files (.env)
- Generate Prisma client
- Create SQLite database
- Process and seed question data
- Start both backend and frontend servers
- Open separate terminal windows for each server

### Stop All Servers
```cmd
# Stop all running servers
setup\windows\stop_dev.bat
```

## Prerequisites

Before running the development script, ensure you have:

1. **Node.js** (v14 or higher)
   - Download from: https://nodejs.org/
   - Choose the LTS version

2. **Conda** (optional, for Python data processing)
   - If you have conda installed, the script will use it
   - If not, it will use system Python

3. **Git** (for cloning the repository)

## What the Script Does

### Automatic Setup Steps:
1. **Prerequisites Check**
   - Verifies Node.js and npm are installed
   - Checks for conda availability

2. **Dependency Installation**
   - Installs backend dependencies (`npm install`)
   - Installs frontend dependencies (`npm install`)

3. **Environment Configuration**
   - Creates backend `.env` file with database and port settings
   - Creates frontend `.env` file with API URL

4. **Database Setup**
   - Generates Prisma client
   - Creates SQLite database
   - Processes question data (if needed)
   - Seeds database with questions

5. **Server Startup**
   - Starts backend server on port 5001
   - Starts frontend server on port 3000
   - Opens separate terminal windows for each

## Server Information

When the script completes successfully, you'll have:

- **Backend API**: http://localhost:5001
- **Frontend App**: http://localhost:3000
- **Database**: SQLite file at `backend/dev.db`
- **Prisma Studio**: http://localhost:5555 (optional)

## Development Commands

### Manual Server Management
```cmd
# Start backend only
cd backend
npm start

# Start frontend only
cd frontend
npm start

# Start backend with auto-restart (development)
cd backend
npm run dev
```

### Database Management
```cmd
# View database in browser
cd backend
npx prisma studio

# Reset database
cd backend
rm dev.db
npx prisma db push
npm run db:seed
```

### Data Processing
```cmd
# Process question data (if needed)
cd data
python convertJSON.py
```

## File Structure

```
sat-practice-app/
├── data/                    # Data processing files
│   ├── convertJSON.py      # Question processing script
│   ├── cb-digital-questions.json  # Original questions
│   └── cleaned_questions_full.json # Processed questions
├── setup/                   # Setup and configuration files
│   ├── windows/            # Windows-specific scripts
│   │   ├── start_dev.bat   # Development startup
│   │   └── stop_dev.bat    # Development stop
│   └── docs/               # Documentation
├── backend/                 # Node.js/Express API
└── frontend/               # React application
```

## Troubleshooting

### Common Issues

1. **Port already in use**
   ```cmd
   setup\windows\stop_dev.bat
   setup\windows\start_dev.bat
   ```

2. **Database issues**
   ```cmd
   cd backend
   del dev.db
   npx prisma db push
   npm run db:seed
   ```

3. **Dependencies issues**
   ```cmd
   cd backend && npm install
   cd ../frontend && npm install
   ```

4. **Data processing issues**
   ```cmd
   cd data
   python convertJSON.py
   ```

## Quick Reference

| Command | Description |
|---------|-------------|
| `setup\windows\start_dev.bat` | Start development environment |
| `setup\windows\stop_dev.bat` | Stop all servers |
| `cd backend && npm run dev` | Start backend with auto-restart |
| `cd frontend && npm start` | Start frontend only |
| `cd backend && npx prisma studio` | View database in browser |
| `cd data && python convertJSON.py` | Process question data |

## Next Steps

After running the development script:

1. **Access the app**: Open http://localhost:3000 in your browser
2. **Test the API**: Visit http://localhost:5001/api/health
3. **View database**: Run `cd backend && npx prisma studio`
4. **Make changes**: Edit files in `frontend/src` or `backend/src`
5. **Restart servers**: Use the stop/start scripts as needed

The development environment is now ready for coding! 