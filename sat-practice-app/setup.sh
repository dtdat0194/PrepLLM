#!/bin/bash

echo "🚀 Setting up SAT Practice Platform..."

# Check if Node.js is installed
if ! command -v node &> /dev/null; then
    echo "❌ Node.js is not installed. Please install Node.js first."
    exit 1
fi

# Check if PostgreSQL is running
if ! pg_isready -q; then
    echo "❌ PostgreSQL is not running. Please start PostgreSQL first."
    exit 1
fi

echo "📦 Setting up backend..."
cd backend

# Install dependencies
npm install

# Create .env file if it doesn't exist
if [ ! -f .env ]; then
    echo "Creating .env file..."
    cat > .env << EOF
DATABASE_URL="postgresql://postgres:password@localhost:5432/sat_practice_db"
PORT=5000
NODE_ENV=development
EOF
    echo "⚠️  Please update the DATABASE_URL in backend/.env with your PostgreSQL credentials"
fi

# Generate Prisma client
npm run db:generate

# Push database schema
npm run db:push

echo "📦 Setting up frontend..."
cd ../frontend

# Install dependencies
npm install

echo "✅ Setup complete!"
echo ""
echo "Next steps:"
echo "1. Update the DATABASE_URL in backend/.env with your PostgreSQL credentials"
echo "2. Start the backend: cd backend && npm run dev"
echo "3. Start the frontend: cd frontend && npm start"
echo "4. Load questions by clicking 'Load Questions' in the app"
echo ""
echo "🎉 Happy coding!" 