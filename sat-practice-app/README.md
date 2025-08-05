# SAT Practice Platform

A comprehensive full-stack SAT practice platform built with React, Node.js, Express, and PostgreSQL. Features advanced question filtering, LaTeX math rendering, and a modern responsive interface.

## 🚀 Quick Start

**One-command startup for the entire platform:**

```bash
# Navigate to the project directory
cd sat-practice-app

# Run the complete startup script
./start.sh
```

This will automatically:
- ✅ Check prerequisites (Node.js, npm, PostgreSQL)
- ✅ Set up the database and seed with questions
- ✅ Install dependencies for both backend and frontend
- ✅ Start both servers
- ✅ Provide health checks and status information

**To stop the platform:**
```bash
./stop.sh
```

## ✨ Features

- **📚 Question Viewer**: Browse through SAT questions one at a time with navigation
- **🔍 Advanced Filtering**: Filter by subject, skill, difficulty, and question type
- **🧮 Math Rendering**: LaTeX math equations rendered with KaTeX
- **📱 Responsive Design**: Modern UI with Tailwind CSS
- **🗄️ Database Integration**: PostgreSQL with Prisma ORM
- **🔧 RESTful API**: Complete backend API for question management
- **📊 Pagination**: Efficient question loading with pagination
- **🎯 Question Types**: Support for multiple-choice and grid-in questions
- **💡 Explanations**: Detailed explanations for each question

## 🛠️ Tech Stack

### Backend
- **Node.js** with Express.js
- **PostgreSQL** database
- **Prisma ORM** for database management
- **RESTful API** design
- **CORS** enabled for frontend communication

### Frontend
- **React.js** with hooks
- **Tailwind CSS** for styling
- **KaTeX** for math rendering
- **React Router** for navigation
- **Axios** for API communication

## 📋 Prerequisites

- **Node.js** (v14 or higher)
- **PostgreSQL** database (running)
- **npm** or yarn
- **Git** (for cloning)

## 🏗️ Project Structure

```
sat-practice-app/
├── 📁 backend/
│   ├── 📁 src/
│   │   ├── 📁 routes/          # API route definitions
│   │   │   ├── questionRoutes.js
│   │   │   ├── skillRoutes.js
│   │   │   └── moduleRoutes.js
│   │   ├── 📁 controllers/     # Request handlers
│   │   │   ├── questionController.js
│   │   │   ├── skillController.js
│   │   │   └── moduleController.js
│   │   ├── 📁 models/          # Database models
│   │   │   └── prisma.js
│   │   ├── 📁 seed/           # Database seeding
│   │   │   └── seed.js
│   │   └── app.js             # Express app setup
│   ├── 📁 prisma/
│   │   └── schema.prisma      # Database schema
│   ├── package.json
│   └── .env                   # Environment variables
├── 📁 frontend/
│   ├── 📁 src/
│   │   ├── 📁 components/     # React components
│   │   │   ├── QuestionViewer.js
│   │   │   └── FilterPanel.js
│   │   ├── 📁 pages/          # Page components
│   │   │   └── PracticePage.js
│   │   ├── 📁 api/           # API service
│   │   │   └── api.js
│   │   ├── App.js            # Main app component
│   │   └── index.css         # Global styles
│   ├── package.json
│   └── tailwind.config.js    # Tailwind configuration
├── 📄 cb-digital-questions.json  # Question data source
├── 📄 start.sh               # Complete startup script
├── 📄 stop.sh                # Shutdown script
├── 📄 setup.sh               # Initial setup script
├── 📄 package.json           # Root package.json
└── 📄 README.md              # This file
```

## 🔧 Manual Setup (Alternative)

If you prefer manual setup or need to troubleshoot:

### 1. Database Setup

```bash
# Create PostgreSQL database
createdb sat_practice_db
```

### 2. Backend Setup

```bash
cd backend

# Install dependencies
npm install

# Create environment file
cat > .env << EOF
DATABASE_URL="postgresql://postgres@localhost:5432/sat_practice_db"
PORT=5001
NODE_ENV=development
EOF

# Generate Prisma client
npm run db:generate

# Push database schema
npm run db:push

# Seed the database with questions
npm run db:seed

# Start the development server
npm run dev
```

### 3. Frontend Setup

```bash
cd frontend

# Install dependencies
npm install

# Start the development server
npm start
```

## 🌐 API Endpoints

### Questions
- `GET /api/questions` - Get questions with optional filters
- `GET /api/questions/:id` - Get single question by ID
- `GET /api/questions/uid/:uId` - Get single question by uId
- `POST /api/questions/bulk` - Bulk load questions from JSON

### Skills
- `GET /api/skills` - Get all skills

### Modules
- `GET /api/modules` - Get all modules

### Health Check
- `GET /api/health` - API health status

## 🗄️ Database Schema

### Questions Table
- `id` - Primary key
- `uId` - Unique identifier from JSON
- `program` - Program name (e.g., "SAT")
- `module` - Subject module (e.g., "math", "reading")
- `skillDesc` - Skill description
- `difficulty` - Question difficulty (1-3)
- `stem` - Question content (HTML)
- `rationale` - Explanation (HTML)
- `correctAnswer` - Array of correct answers
- `contentType` - Question type

### Answer Options Table
- `id` - Primary key
- `questionId` - Foreign key to questions
- `option` - Answer option text
- `order` - Display order

### Skills Table
- `code` - Skill code
- `description` - Skill description

### Modules Table
- `name` - Module name

## 🎯 Usage Guide

### 1. **Start the Platform**
```bash
./start.sh
```

### 2. **Access the Application**
- Frontend: http://localhost:3000
- Backend API: http://localhost:5001

### 3. **Using the Platform**
- **Filter Questions**: Use the filter panel to select by subject, skill, or difficulty
- **Navigate Questions**: Use Previous/Next buttons or click on question numbers
- **View Explanations**: Click "Show Explanation" to see detailed explanations
- **Answer Questions**: Select multiple choice options or enter grid-in answers

## 🔍 Development Commands

### Backend Development
```bash
cd backend
npm run dev          # Start with nodemon for auto-reload
npm run db:generate  # Generate Prisma client
npm run db:push      # Push schema changes
npm run db:seed      # Seed database
```

### Frontend Development
```bash
cd frontend
npm start            # Start React development server
npm run build        # Build for production
```

### Root Level Commands
```bash
npm run dev          # Start both frontend and backend
npm run backend      # Start only backend
npm run frontend     # Start only frontend
```

## 🐛 Troubleshooting

### Common Issues

**1. Port Conflicts**
```bash
# Check what's using the ports
lsof -i :3000
lsof -i :5001

# Kill processes if needed
kill -9 <PID>
```

**2. Database Issues**
```bash
cd backend
npm run db:push      # Reset database schema
npm run db:seed      # Re-seed database
```

**3. Frontend Build Issues**
```bash
cd frontend
rm -rf node_modules package-lock.json
npm install
```

**4. Backend Issues**
```bash
cd backend
rm -rf node_modules package-lock.json
npm install
npm run db:generate
```

### Log Files
- Backend logs: `backend.log`
- Frontend logs: `frontend.log`

### View Logs
```bash
tail -f backend.log   # View backend logs
tail -f frontend.log  # View frontend logs
```

## 📊 Data Source

The platform uses the `cb-digital-questions.json` file containing:
- **24MB** of SAT question data
- **Multiple question types** (multiple-choice, grid-in)
- **Rich content** with HTML and LaTeX math
- **Comprehensive metadata** (skills, modules, difficulty levels)

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📝 License

This project is licensed under the MIT License.

## 🙏 Acknowledgments

- **College Board** for the question data
- **KaTeX** for math rendering
- **Tailwind CSS** for styling
- **Prisma** for database management

---

**Happy SAT Practice! 🎓** 