#!/bin/bash

# SomoCore Stack - Development Mode
# This script starts all services in development mode with hot reloading

echo "🔧 Starting SomoCore Stack in Development Mode..."
echo "================================================"

# Check if Docker is running
if ! docker info > /dev/null 2>&1; then
    echo "❌ Docker is not running. Please start Docker and try again."
    exit 1
fi

# Start backend services with development configuration
echo "🔧 Starting backend services (development mode)..."
cd backend
docker-compose -f docker-compose.dev.yml up -d
cd ..

# Wait for services to be ready
echo "⏳ Waiting for services to be ready..."
sleep 10

# Start dashboard in development mode
if [ -f "dashboard/package.json" ]; then
    echo "🎛️ Starting dashboard (development mode with hot reload)..."
    cd dashboard
    if [ ! -d "node_modules" ]; then
        echo "📦 Installing dashboard dependencies..."
        npm install
    fi
    # Start dashboard in background with hot reload
    npm run dev &
    DASHBOARD_PID=$!
    cd ..
else
    echo "⚠️ Dashboard not found"
fi

# Setup mobile development
if [ -f "mobile/pubspec.yaml" ]; then
    echo "📱 Setting up mobile development environment..."
    cd mobile
    if [ ! -d ".dart_tool" ]; then
        echo "📦 Getting Flutter dependencies..."
        flutter pub get
    fi
    echo "   📱 Mobile app ready for development"
    echo "   🏃 To run: cd mobile && flutter run"
    echo "   🐛 To debug: cd mobile && flutter run --debug"
    cd ..
fi

echo ""
echo "🎉 Development environment started!"
echo ""
echo "🌐 Development URLs:"
echo "   • Backend API: http://localhost:3000"
echo "   • Dashboard: http://localhost:3001 (hot reload enabled)"
echo "   • API Health: http://localhost:3000/health"
echo "   • API Docs: http://localhost:3000/docs"
echo ""
echo "🛠️ Development Tools:"
echo "   • MongoDB Express: http://localhost:8081 (admin/admin)"
echo "   • Redis Commander: http://localhost:8082"
echo "   • MinIO Console: http://localhost:9003 (minioadmin/minioadmin)"
echo "   • MailHog: http://localhost:8025"
echo ""
echo "📋 Development Commands:"
echo "   • View logs: ./scripts/logs-all.sh"
echo "   • Run tests: ./scripts/test-all.sh"
echo "   • Stop all: ./scripts/stop-all.sh"
echo ""
echo "🔍 Backend Debug: Debug port available on localhost:9229" 