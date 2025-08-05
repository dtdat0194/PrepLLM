# SAT Practice App

A comprehensive full-stack SAT practice platform built with React, Node.js, Express, and SQLite. Features advanced question filtering, LaTeX math rendering, and a modern responsive interface.

## Features

- **Question Bank**: Comprehensive SAT question database with 2000+ questions
- **Advanced Filtering**: Filter by section, domain, skill, difficulty, and type
- **Responsive Design**: Works on desktop, tablet, and mobile
- **Modern UI**: Clean, intuitive interface with Tailwind CSS
- **LaTeX Math Rendering**: KaTeX for mathematical expressions
- **Fast Performance**: Optimized for quick question loading
- **Easy Setup**: Simple installation and configuration

## Tech Stack

- **Frontend**: React 19, Tailwind CSS, KaTeX, Axios
- **Backend**: Node.js, Express, Prisma ORM
- **Database**: SQLite (file-based, no server required)
- **Development**: Hot reloading, development tools

## Prerequisites

- **Node.js** (v18 or higher)
- **npm** (comes with Node.js)
- **Python 3.8+** (for data processing)
- **Conda** (optional, for Python environment)
- **Git** (for cloning the repository)

## Quick Start

### Windows Development
```cmd
# Navigate to the project directory
cd sat-practice-app

# Run the automated development startup script
setup\windows\start_dev.bat
```

### Linux/Mac Development
```bash
# Navigate to the project directory
cd sat-practice-app

# Run the setup script
./setup/unix/setup.sh

# Start the application
./setup/unix/start.sh
```

### Access the App

- **Frontend**: http://localhost:3000
- **Backend API**: http://localhost:5001
- **Database**: SQLite file (backend/dev.db)
- **Prisma Studio**: http://localhost:5555 (optional)

## Database Setup

The app uses SQLite, which is automatically configured during setup:

```bash
# The database file will be created at: backend/dev.db
# To seed the database with questions:
cd backend
npm run db:seed
```

## Development

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

## Project Structure

```
sat-practice-app/
├── data/                    # Data processing files
│   ├── convertJSON.py      # Question processing script
│   ├── cb-digital-questions.json  # Original questions (24MB)
│   └── cleaned_questions_full.json # Processed questions (7.5MB)
├── setup/                   # All setup and configuration files
│   ├── windows/            # Windows-specific scripts
│   │   ├── start_dev.bat   # Windows development startup
│   │   ├── stop_dev.bat    # Windows development stop
│   │   ├── start.bat       # Windows production startup
│   │   ├── install-prerequisites.bat
│   │   └── troubleshoot.bat
│   ├── unix/               # Unix/Linux/Mac scripts
│   │   ├── setup.sh        # Unix setup script
│   │   ├── start.sh        # Unix start script
│   │   └── stop.sh         # Unix stop script
│   └── docs/               # Documentation
│       ├── README-DEV.md   # Development guide
│       ├── README-Windows.md # Windows setup guide
│       └── README.md       # Setup documentation
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
├── README.md              # Main documentation
├── TECHNICAL.md           # Technical documentation
└── .gitignore             # Git ignore file
```

## Configuration

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

## API Endpoints

### Core Endpoints
- `GET /api/health` - Health check
- `GET /api/questions` - Get questions with filters
- `GET /api/questions/:id` - Get single question
- `GET /api/questions/questionId/:questionId` - Get by question ID
- `GET /api/questions/filters` - Get available filters

### Query Parameters
- `section`: "Math" or "Reading and Writing"
- `domain`: Specific domain (e.g., "Algebra", "Geometry")
- `skill`: Specific skill description
- `difficulty`: 1 (Easy), 2 (Medium), 3 (Hard)
- `type`: "multiple-choice" or "grid-in"
- `limit`: Number of questions per page (default: 50)
- `offset`: Pagination offset (default: 0)

## Deployment

### Local Development
```bash
# Windows
setup\windows\start_dev.bat

# Unix/Linux/Mac
./setup/unix/start.sh
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

## Troubleshooting

### Common Issues

1. **Port already in use**
   ```bash
   # Windows
   setup\windows\stop_dev.bat
   setup\windows\start_dev.bat
   
   # Unix
   ./setup/unix/stop.sh
   ./setup/unix/start.sh
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

4. **Data processing issues**
   ```bash
   cd data
   python convertJSON.py
   ```

## Documentation

- **[TECHNICAL.md](TECHNICAL.md)**: Comprehensive technical documentation
- **[setup/docs/README-DEV.md](setup/docs/README-DEV.md)**: Development guide
- **[setup/docs/README-Windows.md](setup/docs/README-Windows.md)**: Windows setup guide

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## License

This project is licensed under the MIT License.

---

**Happy coding!** 