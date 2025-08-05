#!/bin/bash

# SAT Practice Platform - Complete Startup Script
# This script sets up and starts the entire SAT practice platform

set -e  # Exit on any error

echo "🚀 Starting SAT Practice Platform..."
echo "=================================="

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if we're in the right directory
if [ ! -f "package.json" ] || [ ! -d "backend" ] || [ ! -d "frontend" ]; then
    print_error "Please run this script from the sat-practice-app directory"
    exit 1
fi

# Check prerequisites
print_status "Checking prerequisites..."

# Check Node.js
if ! command -v node &> /dev/null; then
    print_error "Node.js is not installed. Please install Node.js first."
    exit 1
fi

# Check npm
if ! command -v npm &> /dev/null; then
    print_error "npm is not installed. Please install npm first."
    exit 1
fi

# Check PostgreSQL
if ! command -v psql &> /dev/null; then
    print_error "PostgreSQL is not installed. Please install PostgreSQL first."
    exit 1
fi

# Check if PostgreSQL is running
if ! pg_isready -q; then
    print_error "PostgreSQL is not running. Please start PostgreSQL first."
    exit 1
fi

print_success "All prerequisites are satisfied!"

# Kill any existing processes
print_status "Stopping any existing processes..."
pkill -f "react-scripts" 2>/dev/null || true
pkill -f "nodemon" 2>/dev/null || true
pkill -f "node.*app.js" 2>/dev/null || true

# Kill processes on ports 3000 and 5001
lsof -ti:3000 | xargs kill -9 2>/dev/null || true
lsof -ti:5001 | xargs kill -9 2>/dev/null || true

print_success "Stopped existing processes"

# Database setup
print_status "Setting up database..."

# Create database if it doesn't exist
if ! psql -lqt | cut -d \| -f 1 | grep -qw sat_practice_db; then
    print_status "Creating database..."
    createdb sat_practice_db
    print_success "Database created"
else
    print_status "Database already exists"
fi

# Backend setup
print_status "Setting up backend..."

cd backend

# Install dependencies if node_modules doesn't exist
if [ ! -d "node_modules" ]; then
    print_status "Installing backend dependencies..."
    npm install
    print_success "Backend dependencies installed"
else
    print_status "Backend dependencies already installed"
fi

# Create .env file if it doesn't exist
if [ ! -f ".env" ]; then
    print_status "Creating backend environment file..."
    cat > .env << EOF
DATABASE_URL="postgresql://postgres@localhost:5432/sat_practice_db"
PORT=5001
NODE_ENV=development
EOF
    print_success "Environment file created"
fi

# Generate Prisma client
print_status "Generating Prisma client..."
npm run db:generate

# Push database schema
print_status "Setting up database schema..."
npm run db:push

# Seed database if it's empty
QUESTION_COUNT=$(psql -d sat_practice_db -t -c "SELECT COUNT(*) FROM questions;" | xargs)
if [ "$QUESTION_COUNT" -eq 0 ]; then
    print_status "Seeding database with questions..."
    npm run db:seed
    print_success "Database seeded with questions"
else
    print_status "Database already contains $QUESTION_COUNT questions"
fi

# Start backend server in background
print_status "Starting backend server..."
npm run dev > ../backend.log 2>&1 &
BACKEND_PID=$!
echo $BACKEND_PID > ../backend.pid

# Wait for backend to start
print_status "Waiting for backend to start..."
sleep 5

# Test backend
if curl -s http://localhost:5001/api/health > /dev/null; then
    print_success "Backend is running on http://localhost:5001"
else
    print_error "Backend failed to start. Check backend.log for details."
    exit 1
fi

cd ..

# Frontend setup
print_status "Setting up frontend..."

cd frontend

# Install dependencies if node_modules doesn't exist
if [ ! -d "node_modules" ]; then
    print_status "Installing frontend dependencies..."
    npm install
    print_success "Frontend dependencies installed"
else
    print_status "Frontend dependencies already installed"
fi

# Start frontend server in background
print_status "Starting frontend server..."
npm start > ../frontend.log 2>&1 &
FRONTEND_PID=$!
echo $FRONTEND_PID > ../frontend.pid

cd ..

# Wait for frontend to start
print_status "Waiting for frontend to start..."
sleep 10

# Test frontend
if curl -s http://localhost:3000 > /dev/null; then
    print_success "Frontend is running on http://localhost:3000"
else
    print_warning "Frontend may still be starting up..."
fi

# Create a stop script
cat > stop.sh << 'EOF'
#!/bin/bash
echo "🛑 Stopping SAT Practice Platform..."

# Kill processes by PID if files exist
if [ -f "backend.pid" ]; then
    kill $(cat backend.pid) 2>/dev/null || true
    rm backend.pid
fi

if [ -f "frontend.pid" ]; then
    kill $(cat frontend.pid) 2>/dev/null || true
    rm frontend.pid
fi

# Kill any remaining processes
pkill -f "react-scripts" 2>/dev/null || true
pkill -f "nodemon" 2>/dev/null || true
pkill -f "node.*app.js" 2>/dev/null || true

# Kill processes on ports
lsof -ti:3000 | xargs kill -9 2>/dev/null || true
lsof -ti:5001 | xargs kill -9 2>/dev/null || true

echo "✅ All processes stopped"
EOF

chmod +x stop.sh

# Display final status
echo ""
echo "🎉 SAT Practice Platform is now running!"
echo "========================================"
echo ""
echo "📱 Frontend: http://localhost:3000"
echo "🔧 Backend API: http://localhost:5001"
echo ""
echo "📊 Database: PostgreSQL (sat_practice_db)"
echo "📝 Questions loaded: $QUESTION_COUNT"
echo ""
echo "🛑 To stop the platform, run: ./stop.sh"
echo ""
echo "📋 Useful commands:"
echo "   - View backend logs: tail -f backend.log"
echo "   - View frontend logs: tail -f frontend.log"
echo "   - Restart backend: cd backend && npm run dev"
echo "   - Restart frontend: cd frontend && npm start"
echo ""
echo "🔍 Troubleshooting:"
echo "   - If frontend shows errors, check the browser console (F12)"
echo "   - If backend fails, check backend.log"
echo "   - If database issues, run: cd backend && npm run db:push"
echo ""

# Function to handle cleanup on script exit
cleanup() {
    echo ""
    print_status "Cleaning up..."
    ./stop.sh
    exit 0
}

# Set up signal handlers
trap cleanup SIGINT SIGTERM

print_success "Platform is ready! Open http://localhost:3000 in your browser."
echo ""
echo "Press Ctrl+C to stop all services..."

# Keep the script running
while true; do
    sleep 1
done 