# SAT Practice App - Windows Setup

A comprehensive SAT practice platform built with React, Node.js, Express, and SQLite. Features advanced question filtering, LaTeX math rendering, and a modern responsive interface.

## 🚀 Quick Start for Windows

### Option 1: Automated Setup (Recommended)
```cmd
# Run the complete setup and start script
start.bat
```

This will automatically:
- ✅ Check prerequisites (Node.js, npm)
- ✅ Install dependencies for both backend and frontend
- ✅ Set up SQLite database
- ✅ Start both servers
- ✅ Open the application in your browser

### Option 2: Manual Setup
```cmd
# Install prerequisites
install-prerequisites.bat

# Start the application
start.bat
```

## 📋 Prerequisites

- **Node.js** (v14 or higher) - [Download](https://nodejs.org/)
- **npm** (comes with Node.js)
- **Git** (for cloning) - [Download](https://git-scm.com/)

## 🛠️ Features

- **📚 Question Bank**: Comprehensive SAT question database
- **🔍 Advanced Filtering**: Filter by section, domain, skill, difficulty, and type
- **📱 Responsive Design**: Works on desktop, tablet, and mobile
- **🎨 Modern UI**: Clean, intuitive interface with Tailwind CSS
- **⚡ Fast Performance**: Optimized for quick question loading
- **🔧 Easy Setup**: Simple installation and configuration

## 🗄️ Database

This app uses **SQLite**, which means:
- ✅ No database server installation required
- ✅ Database is just a file (`backend/dev.db`)
- ✅ Automatic setup during installation
- ✅ Easy backup and restore

## 📁 Project Structure

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

## 🔧 Configuration

### Environment Variables

**Backend (.env)**
```env
DATABASE_URL="file:./dev.db"
PORT=5001
```

**Frontend (.env)**
```env
REACT_APP_API_URL=http://localhost:5001/api
```

## 🚀 Usage

### Starting the Application
```cmd
# From the sat-practice-app directory
start.bat
```

### Stopping the Application
- Press `Ctrl+C` in the terminal
- Or close the terminal window

### Accessing the App
- **Frontend**: http://localhost:3000
- **Backend API**: http://localhost:5001
- **Database**: SQLite file (backend/dev.db)

## 🐛 Troubleshooting

### Common Issues

1. **"Node.js is not recognized"**
   - Install Node.js from https://nodejs.org/
   - Restart your computer after installation

2. **"npm is not recognized"**
   - Node.js installation includes npm
   - Try restarting your computer

3. **Port already in use**
   - Close other applications using ports 3000 or 5001
   - Or restart your computer

4. **Database issues**
   ```cmd
   cd backend
   del dev.db
   npx prisma db push
   npm run db:seed
   ```

### Getting Help

- Run `troubleshoot.bat` for automated diagnostics
- Check the browser console (F12) for frontend errors
- Check the terminal for backend error messages

## 📝 API Endpoints

- `GET /api/health` - Health check
- `GET /api/questions` - Get questions with filters
- `GET /api/questions/:id` - Get single question
- `GET /api/questions/questionId/:questionId` - Get by question ID
- `GET /api/questions/filters` - Get available filters

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## 📄 License

This project is licensed under the MIT License.

---

**Happy SAT Practice! 🎓** 