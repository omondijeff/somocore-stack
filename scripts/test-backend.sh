#!/bin/bash

# SomoCore Stack - Backend Tests
# This script runs backend-specific tests

echo "🔧 SomoCore Backend - Test Suite"
echo "================================="

# Check if backend exists
if [ ! -f "backend/package.json" ]; then
    echo "❌ Backend package.json not found"
    exit 1
fi

cd backend

echo "📦 Setting up backend test environment..."

# Install dependencies if needed
if [ ! -d "node_modules" ]; then
    echo "Installing dependencies..."
    npm install
fi

# Check if Docker services are needed for tests
if docker ps | grep -q "somocore"; then
    echo "🐳 Docker services detected - using existing services"
else
    echo "🐳 Starting test database services..."
    docker-compose -f docker-compose.dev.yml up -d mongo redis
    sleep 5
fi

echo ""
echo "🧪 Running backend tests..."
echo "============================"

# Run different types of tests
echo "📝 Unit Tests:"
npm run test

echo ""
echo "🔍 Linting:"
npm run lint

# Run additional test commands if they exist
if npm run | grep -q "test:integration"; then
    echo ""
    echo "🔗 Integration Tests:"
    npm run test:integration
fi

if npm run | grep -q "test:coverage"; then
    echo ""
    echo "📊 Test Coverage:"
    npm run test:coverage
fi

echo ""
echo "✅ Backend testing completed!"

cd .. 