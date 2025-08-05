# SAT Practice App

A comprehensive full-stack SAT practice platform built with React, Node.js, Express, and SQLite. Features advanced question filtering, LaTeX math rendering, and a modern responsive interface.

## 🚀 Features

- **📚 Question Bank**: Comprehensive SAT question database
- **🔍 Advanced Filtering**: Filter by section, domain, skill, difficulty, and type
- **📱 Responsive Design**: Works on desktop, tablet, and mobile
- **🎨 Modern UI**: Clean, intuitive interface with Tailwind CSS
- **⚡ Fast Performance**: Optimized for quick question loading
- **🔧 Easy Setup**: Simple installation and configuration

## 🛠️ Tech Stack

- **Frontend**: React, Tailwind CSS, Axios
- **Backend**: Node.js, Express, Prisma ORM
- **Database**: SQLite (file-based, no server required)
- **Development**: Hot reloading, development tools

## 📋 Prerequisites

- **Node.js** (v14 or higher)
- **npm** (comes with Node.js)
- **Git** (for cloning the repository)

## 🚀 Quick Start

### 1. Clone and Setup

```bash
# Clone the repository
git clone <repository-url>
cd sat-practice-app

# Run the setup script
chmod +x setup.sh
./setup.sh
```

### 2. Start the Application

```bash
# Start both frontend and backend servers
chmod +x start.sh
./start.sh
```

### 3. Access the App

- **Frontend**: http://localhost:3000
- **Backend API**: http://localhost:5001
- **Database**: SQLite file (backend/dev.db)

## 📊 Database Setup

The app uses SQLite, which is automatically configured during setup:

```bash
# The database file will be created at: backend/dev.db
# To seed the database with questions:
cd backend
npm run db:seed
```

## 🛠️ Development

### Backend Development

```bash
cd backend
npm run dev          # Start with nodemon (auto-restart)
npm run db:generate  # Generate Prisma client
npm run db:push      # Push schema changes
npm run db:seed      # Seed database with questions
```

### Frontend Development

```bash
cd frontend
npm start            # Start development server
npm run build        # Build for production
```

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
├── setup.sh               # Setup script
├── start.sh               # Start script
└── stop.sh                # Stop script
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

## 🚀 Deployment

### Local Development
```bash
./start.sh    # Start both servers
./stop.sh     # Stop both servers
```

### Production
```bash
# Build frontend
cd frontend
npm run build

# Start backend
cd backend
npm start
```

## 🐛 Troubleshooting

### Common Issues

1. **Port already in use**
   ```bash
   ./stop.sh  # Stop all servers
   ./start.sh # Restart
   ```

2. **Database issues**
   ```bash
   cd backend
   rm dev.db           # Delete database
   npx prisma db push  # Recreate database
   npm run db:seed     # Seed with data
   ```

3. **Dependencies issues**
   ```bash
   cd backend && npm install
   cd ../frontend && npm install
   ```

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

**Happy coding! 🎉** 