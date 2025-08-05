#!/bin/bash

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo "🚀 Setting up SAT Practice App..."

# Check if Node.js is installed
if ! command -v node &> /dev/null; then
    echo -e "${RED}❌ Node.js is not installed. Please install Node.js first.${NC}"
    exit 1
fi

echo -e "${GREEN}✅ Node.js is installed${NC}"

# Check if npm is installed
if ! command -v npm &> /dev/null; then
    echo -e "${RED}❌ npm is not installed. Please install npm first.${NC}"
    exit 1
fi

echo -e "${GREEN}✅ npm is installed${NC}"

# Install backend dependencies
echo "📦 Installing backend dependencies..."
cd backend
npm install

# Create .env file for backend
if [ ! -f .env ]; then
    echo "📝 Creating .env file for backend..."
    echo "DATABASE_URL=\"file:./dev.db\"" > .env
    echo "PORT=5001" >> .env
    echo -e "${GREEN}✅ Created .env file with SQLite configuration${NC}"
else
    echo -e "${YELLOW}⚠️  .env file already exists. Please make sure DATABASE_URL is set to: file:./dev.db${NC}"
fi

# Generate Prisma client
echo "🔧 Generating Prisma client..."
npx prisma generate

# Push schema to database (creates SQLite database)
echo "🗄️  Setting up SQLite database..."
npx prisma db push

# Install frontend dependencies
echo "📦 Installing frontend dependencies..."
cd ../frontend
npm install

# Create .env file for frontend
if [ ! -f .env ]; then
    echo "📝 Creating .env file for frontend..."
    echo "REACT_APP_API_URL=http://localhost:5001/api" > .env
    echo -e "${GREEN}✅ Created .env file for frontend${NC}"
else
    echo -e "${YELLOW}⚠️  .env file already exists in frontend${NC}"
fi

echo -e "${GREEN}✅ Setup completed successfully!${NC}"
echo ""
echo "🎯 Next steps:"
echo "1. Run the application with: ./start.sh"
echo "2. Seed the database with: cd backend && npm run db:seed"
echo "3. Access the app at: http://localhost:3000" 