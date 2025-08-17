#!/bin/bash

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo "🛑 Stopping SAT Practice App..."

# Kill any existing processes
echo "Stopping backend server..."
pkill -f "node.*app.js" 2>/dev/null || true
pkill -f "nodemon" 2>/dev/null || true

echo "Stopping frontend server..."
pkill -f "react-scripts" 2>/dev/null || true

# Kill processes on ports 3000 and 5001
echo "Cleaning up ports..."
lsof -ti:3000 | xargs kill -9 2>/dev/null || true
lsof -ti:5001 | xargs kill -9 2>/dev/null || true

# Remove PID files if they exist
rm -f backend.pid frontend.pid 2>/dev/null || true

echo -e "${GREEN}✅ All servers stopped${NC}"
echo ""
echo "📝 Note: SQLite database file (dev.db) remains intact"
echo "   To completely reset, delete backend/dev.db and run setup again"
