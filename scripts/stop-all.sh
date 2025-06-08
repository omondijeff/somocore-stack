#!/bin/bash

# SomoCore Stack - Stop All Services
# This script stops all running services

echo "🛑 Stopping SomoCore Stack..."
echo "=============================="

# Stop backend Docker services
if [ -f "backend/docker-compose.dev.yml" ]; then
    echo "🔧 Stopping backend services..."
    cd backend
    docker-compose -f docker-compose.dev.yml down
    cd ..
else
    echo "⚠️ Backend docker-compose.dev.yml not found"
fi

# Stop dashboard (kill Next.js process)
echo "🎛️ Stopping dashboard..."
pkill -f "next dev" || echo "   No dashboard process found"

# Stop any remaining Node.js processes related to the project
echo "🧹 Cleaning up remaining processes..."
pkill -f "somocore" || echo "   No somocore processes found"

echo ""
echo "✅ All services stopped successfully!"
echo ""
echo "🔄 To start services again, run: ./scripts/start-all.sh" 