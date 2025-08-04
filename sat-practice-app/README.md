# SAT Practice Platform

A full-stack SAT practice platform built with React, Node.js, Express, and PostgreSQL.

## Features

- **Question Viewer**: Browse through SAT questions one at a time
- **Advanced Filtering**: Filter by subject, skill, and difficulty
- **Math Rendering**: LaTeX math equations rendered with KaTeX
- **Responsive Design**: Modern UI with Tailwind CSS
- **Database Integration**: PostgreSQL with Prisma ORM
- **RESTful API**: Complete backend API for question management

## Tech Stack

### Backend
- Node.js with Express.js
- PostgreSQL database
- Prisma ORM
- RESTful API design

### Frontend
- React.js
- Tailwind CSS for styling
- KaTeX for math rendering
- React Router for navigation
- Axios for API communication

## Prerequisites

- Node.js (v14 or higher)
- PostgreSQL database
- npm or yarn

## Setup Instructions

### 1. Database Setup

First, create a PostgreSQL database:

```sql
CREATE DATABASE sat_practice_db;
```

### 2. Backend Setup

```bash
cd backend

# Install dependencies
npm install

# Set up environment variables
# Create a .env file with:
DATABASE_URL="postgresql://username:password@localhost:5432/sat_practice_db"
PORT=5000
NODE_ENV=development

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

## API Endpoints

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

## Database Schema

### Questions Table
- `id` - Primary key
- `uId` - Unique identifier from JSON
- `program` - Program name (e.g., "SAT")
- `module` - Subject module (e.g., "math", "reading")
- `skillDesc` - Skill description
- `difficulty` - Question difficulty (E, M, H)
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

## Usage

1. **Load Questions**: Click "Load Questions" to populate the database with questions from the JSON file
2. **Filter Questions**: Use the filter panel to select by subject, skill, or difficulty
3. **Navigate Questions**: Use Previous/Next buttons to browse through questions
4. **View Explanations**: Click "Show Explanation" to see detailed explanations
5. **Answer Questions**: Select multiple choice options or enter grid-in answers

## Development

### Backend Development
```bash
cd backend
npm run dev  # Start with nodemon for auto-reload
```

### Frontend Development
```bash
cd frontend
npm start  # Start React development server
```

### Database Management
```bash
cd backend
npm run db:generate  # Generate Prisma client
npm run db:push      # Push schema changes
npm run db:seed      # Seed database
```

## Project Structure

```
sat-practice-app/
├── backend/
│   ├── src/
│   │   ├── routes/          # API routes
│   │   ├── controllers/     # Request handlers
│   │   ├── models/          # Database models
│   │   ├── seed/           # Database seeding
│   │   └── app.js          # Express app
│   ├── prisma/
│   │   └── schema.prisma   # Database schema
│   └── package.json
├── frontend/
│   ├── src/
│   │   ├── components/     # React components
│   │   ├── pages/          # Page components
│   │   ├── api/           # API service
│   │   └── App.js         # Main app component
│   └── package.json
├── cb-digital-questions.json  # Question data
└── README.md
```

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## License

This project is licensed under the MIT License. 