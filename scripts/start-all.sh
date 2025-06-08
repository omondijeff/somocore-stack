#!/bin/bash

# SomoCore Stack - Start All Services
# This script starts all services using Docker Compose

echo "🚀 Starting SomoCore Stack..."
echo "================================"

# Check if Docker is running
if ! docker info > /dev/null 2>&1; then
    echo "❌ Docker is not running. Please start Docker and try again."
    exit 1
fi

# Check if required files exist
if [ ! -f "backend/docker-compose.dev.yml" ]; then
    echo "❌ Backend docker-compose.dev.yml not found"
    exit 1
fi

# Start backend services
echo "🔧 Starting backend services..."
cd backend
docker-compose -f docker-compose.dev.yml up -d
cd ..

# Check if dashboard exists and has package.json
if [ -f "dashboard/package.json" ]; then
    echo "🎛️ Starting dashboard..."
    cd dashboard
    if [ ! -d "node_modules" ]; then
        echo "📦 Installing dashboard dependencies..."
        npm install
    fi
    npm run dev &
    cd ..
else
    echo "⚠️ Dashboard not found or not set up"
fi

# Check if mobile app can be started (Flutter)
if [ -f "mobile/pubspec.yaml" ]; then
    echo "📱 Mobile app detected (Flutter)"
    echo "   To run mobile app: cd mobile && flutter run"
else
    echo "⚠️ Mobile app not found"
fi

echo ""
echo "✅ SomoCore Stack started successfully!"
echo ""
echo "🌐 Access your services:"
echo "   • Backend API: http://localhost:3000"
echo "   • Dashboard: http://localhost:3001"
echo "   • API Docs: http://localhost:3000/docs"
echo "   • MongoDB Express: http://localhost:8081"
echo "   • Redis Commander: http://localhost:8082"
echo "   • MinIO Console: http://localhost:9003"
echo "   • MailHog: http://localhost:8025"
echo ""
echo "📋 To stop all services, run: ./scripts/stop-all.sh" 