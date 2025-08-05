# SAT Practice App - Technical Documentation

## Table of Contents

1. [Architecture Overview](#architecture-overview)
2. [Technology Stack](#technology-stack)
3. [Database Design](#database-design)
4. [API Design](#api-design)
5. [Frontend Architecture](#frontend-architecture)
6. [Data Processing Pipeline](#data-processing-pipeline)
7. [Development Environment](#development-environment)
8. [Deployment](#deployment)
9. [Performance Considerations](#performance-considerations)
10. [Security Considerations](#security-considerations)

## Architecture Overview

The SAT Practice App is a full-stack web application built with a modern JavaScript stack. It follows a client-server architecture with clear separation of concerns:

```
┌─────────────────┐    HTTP/JSON    ┌─────────────────┐
│   React Frontend │ ◄──────────────► │  Node.js Backend │
│   (Port 3000)   │                 │   (Port 5001)   │
└─────────────────┘                 └─────────────────┘
                                              │
                                              ▼
                                    ┌─────────────────┐
                                    │   SQLite DB     │
                                    │   (Prisma ORM)  │
                                    └─────────────────┘
```

### Key Architectural Decisions

- **SQLite Database**: File-based database for simplicity and portability
- **Prisma ORM**: Type-safe database access with auto-generated client
- **RESTful API**: Standard HTTP endpoints for data access
- **Component-Based UI**: React components with Tailwind CSS styling
- **LaTeX Math Rendering**: KaTeX for mathematical expressions

## Technology Stack

### Backend Stack

| Technology | Version | Purpose |
|------------|---------|---------|
| Node.js | 18+ | Runtime environment |
| Express.js | 4.18.2 | Web framework |
| Prisma | 5.7.1 | Database ORM |
| SQLite | 3.x | Database engine |
| CORS | 2.8.5 | Cross-origin resource sharing |
| dotenv | 16.3.1 | Environment configuration |
| bcryptjs | 2.4.3 | Password hashing |
| jsonwebtoken | 9.0.2 | JWT authentication |
| axios | 1.11.0 | HTTP client |

### Frontend Stack

| Technology | Version | Purpose |
|------------|---------|---------|
| React | 19.1.1 | UI framework |
| React Router | 7.7.1 | Client-side routing |
| Tailwind CSS | 3.4.17 | Utility-first CSS |
| KaTeX | 0.16.22 | LaTeX math rendering |
| Axios | 1.11.0 | HTTP client |
| React Scripts | 5.0.1 | Build tools |

### Development Tools

| Tool | Purpose |
|------|---------|
| Nodemon | Backend auto-restart |
| Prisma Studio | Database GUI |
| React DevTools | Frontend debugging |
| Postman/Insomnia | API testing |

## Database Design

### Schema Overview

The application uses a single `Question` model to store SAT practice questions:

```prisma
model Question {
  id            String   @id @default(cuid())
  questionId    String   @unique // Original ID from JSON
  program       String
  section       String   // "Math" or "Reading and Writing"
  domain        String   // "Algebra", "Geometry", etc.
  skill         String   // Specific skill description
  difficulty    Int      // 1, 2, 3 for Easy, Medium, Hard
  type          String   // "multiple-choice" or "grid-in"
  
  // Question content
  paragraph     String?
  questionText  String
  choices       String   // JSON string
  correctAnswer String   // JSON string
  explanation   String?
  
  // Visual content
  visualType    String?
  svgContent    String?
  imageUrl      String?
  
  createdAt     DateTime @default(now())
  updatedAt     DateTime @updatedAt

  @@map("questions")
}
```

### Database Features

- **SQLite**: File-based, no server required
- **JSON Storage**: Arrays stored as JSON strings for SQLite compatibility
- **Indexing**: Automatic indexing on `questionId` for fast lookups
- **Timestamps**: Automatic creation and update timestamps

### Data Relationships

The current design uses a denormalized approach where all question data is stored in a single table. This provides:

- **Fast Queries**: No joins required
- **Simple Schema**: Easy to understand and maintain
- **Flexible Filtering**: All fields available for filtering

## API Design

### RESTful Endpoints

#### Health Check
```
GET /api/health
Response: { "status": "ok", "timestamp": "2024-01-01T00:00:00Z" }
```

#### Questions
```
GET /api/questions
Query Parameters:
  - section: "Math" | "Reading and Writing"
  - domain: string
  - skill: string
  - difficulty: 1 | 2 | 3
  - type: "multiple-choice" | "grid-in"
  - limit: number (default: 50)
  - offset: number (default: 0)

Response: {
  "questions": [...],
  "total": number,
  "limit": number,
  "offset": number
}
```

```
GET /api/questions/:id
Response: { "question": {...} }
```

```
GET /api/questions/questionId/:questionId
Response: { "question": {...} }
```

#### Filters
```
GET /api/questions/filters
Response: {
  "sections": [...],
  "domains": [...],
  "skills": [...],
  "difficulties": [...],
  "types": [...]
}
```

### API Features

- **Pagination**: Limit/offset pagination for large datasets
- **Filtering**: Multiple filter parameters supported
- **CORS**: Cross-origin requests enabled
- **Error Handling**: Standardized error responses
- **Validation**: Input validation on all endpoints

### Response Format

```json
{
  "success": true,
  "data": {...},
  "message": "Success message",
  "timestamp": "2024-01-01T00:00:00Z"
}
```

### Error Response Format

```json
{
  "success": false,
  "error": "Error message",
  "code": "ERROR_CODE",
  "timestamp": "2024-01-01T00:00:00Z"
}
```

## Frontend Architecture

### Component Structure

```
src/
├── components/
│   ├── FilterPanel.js      # Question filtering interface
│   └── QuestionViewer.js   # Question display component
├── pages/
│   └── PracticePage.js     # Main practice page
├── api/
│   └── api.js             # API client functions
├── App.js                 # Main application component
└── index.js              # Application entry point
```

### Key Components

#### FilterPanel Component
- **Purpose**: Provides filtering interface for questions
- **Features**: Multi-select filters, search, difficulty selection
- **State Management**: Local React state with controlled inputs

#### QuestionViewer Component
- **Purpose**: Displays individual questions with LaTeX rendering
- **Features**: Math rendering, choice selection, explanation display
- **Dependencies**: KaTeX for mathematical expressions

### State Management

The application uses React's built-in state management:

- **Local State**: Component-level state for UI interactions
- **Props**: Data flow from parent to child components
- **Context**: Future consideration for global state if needed

### Routing

Single-page application with React Router:

- **Main Route**: `/` - Practice page with filtering
- **Future Routes**: `/question/:id` for individual questions

## Data Processing Pipeline

### Data Flow

```
Raw JSON Data → Python Processing → Cleaned JSON → Database Seeding → API Access
```

### Processing Steps

1. **Raw Data**: `cb-digital-questions.json` (24MB)
2. **Python Processing**: `convertJSON.py` transforms data
3. **Cleaned Data**: `cleaned_questions_full.json` (7.5MB)
4. **Database Seeding**: Node.js script populates SQLite
5. **API Access**: RESTful endpoints serve data

### Data Transformation

The Python script (`convertJSON.py`) performs:

- **Difficulty Conversion**: String to integer mapping
- **Type Standardization**: Question type normalization
- **HTML Stripping**: Clean text content
- **Structure Validation**: Ensure required fields exist

### Seeding Process

The Node.js seeding script:

- **Checks Existing**: Prevents duplicate questions
- **Batch Processing**: Processes questions in batches
- **Error Handling**: Continues on individual question errors
- **Progress Reporting**: Shows processing statistics

## Development Environment

### Local Development Setup

#### Prerequisites
- Node.js 18+
- npm or yarn
- Python 3.8+ (for data processing)
- Conda (optional, for Python environment)

#### Environment Variables

**Backend (.env)**
```env
DATABASE_URL="file:./dev.db"
PORT=5001
NODE_ENV=development
```

**Frontend (.env)**
```env
REACT_APP_API_URL=http://localhost:5001/api
```

### Development Scripts

#### Backend Scripts
```bash
npm start          # Start production server
npm run dev        # Start with nodemon (auto-restart)
npm run db:generate # Generate Prisma client
npm run db:push    # Push schema to database
npm run db:seed    # Seed database with questions
```

#### Frontend Scripts
```bash
npm start          # Start development server
npm run build      # Build for production
npm test           # Run tests
```

### Development Workflow

1. **Start Backend**: `cd backend && npm run dev`
2. **Start Frontend**: `cd frontend && npm start`
3. **Database Management**: Use Prisma Studio for data inspection
4. **API Testing**: Use Postman or browser for endpoint testing

## Deployment

### Production Build

#### Frontend Build
```bash
cd frontend
npm run build
```

The build creates a `build/` directory with optimized static files.

#### Backend Deployment
```bash
cd backend
npm start
```

### Environment Configuration

#### Production Environment Variables
```env
DATABASE_URL="file:./dev.db"
PORT=5001
NODE_ENV=production
```

#### Frontend Environment Variables
```env
REACT_APP_API_URL=https://your-api-domain.com/api
```

### Deployment Options

1. **Heroku**: Easy deployment with Procfile
2. **Vercel**: Frontend deployment with serverless functions
3. **AWS**: EC2 for backend, S3 for frontend
4. **Docker**: Containerized deployment

### Docker Configuration

```dockerfile
# Backend Dockerfile
FROM node:18-alpine
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
RUN npm run db:generate
EXPOSE 5001
CMD ["npm", "start"]
```

## Performance Considerations

### Database Performance

- **Indexing**: Automatic indexing on `questionId`
- **Query Optimization**: Efficient filtering with WHERE clauses
- **Pagination**: Prevents large result sets
- **Connection Pooling**: Prisma handles connection management

### Frontend Performance

- **Code Splitting**: React.lazy for component loading
- **Bundle Optimization**: Webpack optimization in production
- **Caching**: Browser caching for static assets
- **Lazy Loading**: Components loaded on demand

### API Performance

- **Response Caching**: Consider Redis for frequently accessed data
- **Database Indexing**: Optimize query performance
- **Compression**: Enable gzip compression
- **CDN**: Use CDN for static assets

## Security Considerations

### API Security

- **Input Validation**: Validate all user inputs
- **SQL Injection**: Prisma ORM prevents SQL injection
- **CORS Configuration**: Proper CORS setup for cross-origin requests
- **Rate Limiting**: Consider implementing rate limiting

### Frontend Security

- **XSS Prevention**: React's built-in XSS protection
- **Content Security Policy**: Implement CSP headers
- **HTTPS**: Use HTTPS in production
- **Environment Variables**: Secure handling of sensitive data

### Data Security

- **Database Security**: SQLite file permissions
- **Backup Strategy**: Regular database backups
- **Data Validation**: Validate data at multiple layers
- **Error Handling**: Don't expose sensitive information in errors

## Monitoring and Logging

### Application Monitoring

- **Health Checks**: `/api/health` endpoint
- **Error Logging**: Implement proper error logging
- **Performance Monitoring**: Monitor response times
- **Database Monitoring**: Track query performance

### Logging Strategy

```javascript
// Example logging implementation
const winston = require('winston');

const logger = winston.createLogger({
  level: 'info',
  format: winston.format.json(),
  transports: [
    new winston.transports.File({ filename: 'error.log', level: 'error' }),
    new winston.transports.File({ filename: 'combined.log' })
  ]
});
```

## Future Enhancements

### Planned Features

1. **User Authentication**: JWT-based user system
2. **Progress Tracking**: User progress and statistics
3. **Question Bookmarking**: Save favorite questions
4. **Practice Sessions**: Timed practice sessions
5. **Performance Analytics**: Detailed performance metrics

### Technical Improvements

1. **Caching Layer**: Redis for improved performance
2. **Search Functionality**: Full-text search capabilities
3. **Real-time Updates**: WebSocket for live updates
4. **Mobile App**: React Native version
5. **Offline Support**: Service workers for offline access

---

**Last Updated**: January 2024
**Version**: 1.0.0 