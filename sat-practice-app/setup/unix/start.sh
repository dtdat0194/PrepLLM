#!/bin/bash

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_success() {
    echo -e "${GREEN}$1${NC}"
}

print_error() {
    echo -e "${RED}$1${NC}"
}

print_warning() {
    echo -e "${YELLOW}$1${NC}"
}

print_info() {
    echo -e "${BLUE}$1${NC}"
}

echo "Starting SAT Practice App..."

# Check if Node.js is installed
if ! command -v node &> /dev/null; then
    print_error "Node.js is not installed. Please install Node.js first."
    exit 1
fi

print_success "Node.js is installed"

# Check if npm is installed
if ! command -v npm &> /dev/null; then
    print_error "npm is not installed. Please install npm first."
    exit 1
fi

print_success "npm is installed"

# Check if backend directory exists
if [ ! -d "backend" ]; then
    print_error "Backend directory not found. Please run setup.sh first."
    exit 1
fi

# Check if frontend directory exists
if [ ! -d "frontend" ]; then
    print_error "Frontend directory not found. Please run setup.sh first."
    exit 1
fi

# Check if backend dependencies are installed
if [ ! -d "backend/node_modules" ]; then
    print_warning "Backend dependencies not installed. Installing now..."
    cd backend
    npm install
    cd ..
fi

# Check if frontend dependencies are installed
if [ ! -d "frontend/node_modules" ]; then
    print_warning "Frontend dependencies not installed. Installing now..."
    cd frontend
    npm install
    cd ..
fi

# Check if .env file exists in backend
if [ ! -f "backend/.env" ]; then
    print_warning "Backend .env file not found. Creating default configuration..."
    cd backend
    echo "DATABASE_URL=\"file:./dev.db\"" > .env
    echo "PORT=5001" >> .env
    cd ..
fi

# Check if .env file exists in frontend
if [ ! -f "frontend/.env" ]; then
    print_warning "Frontend .env file not found. Creating default configuration..."
    cd frontend
    echo "REACT_APP_API_URL=http://localhost:5001/api" > .env
    cd ..
fi

# Generate Prisma client if needed
cd backend
if [ ! -d "node_modules/.prisma" ]; then
    print_info "Generating Prisma client..."
    npx prisma generate
fi

# Check if database exists, if not create it
if [ ! -f "dev.db" ]; then
    print_info "Creating SQLite database..."
    npx prisma db push
fi

cd ..

# Function to cleanup background processes
cleanup() {
    print_info "Shutting down servers..."
    kill $BACKEND_PID $FRONTEND_PID 2>/dev/null
    exit 0
}

# Set up signal handlers
trap cleanup SIGINT SIGTERM

# Start backend server
print_info "Starting backend server..."
cd backend
npm start &
BACKEND_PID=$!
cd ..

# Wait a moment for backend to start
sleep 2

# Check if backend is running
if ! curl -s http://localhost:5001/api/health > /dev/null; then
    print_warning "Backend might still be starting up..."
    sleep 3
fi

# Start frontend server
print_info "Starting frontend server..."
cd frontend
npm start &
FRONTEND_PID=$!
cd ..

# Wait for servers to start
sleep 3

# Check if servers are running
if curl -s http://localhost:5001/api/health > /dev/null; then
    print_success "Backend server is running on http://localhost:5001"
else
    print_error "Backend server failed to start"
fi

if curl -s http://localhost:3000 > /dev/null; then
    print_success "Frontend server is running on http://localhost:3000"
else
    print_warning "Frontend server might still be starting up..."
fi

echo ""
echo "SAT Practice App is starting up!"
echo ""
echo "Server Status:"
echo "   Backend:  http://localhost:5001"
echo "   Frontend: http://localhost:3000"
echo "   Database: SQLite (dev.db)"
echo ""
echo "Next steps:"
echo "   1. Wait for both servers to fully start"
echo "   2. Open http://localhost:3000 in your browser"
echo "   3. If you need to seed the database, run: cd backend && npm run db:seed"
echo ""
echo "Press Ctrl+C to stop all servers"

# Wait for background processes
wait 