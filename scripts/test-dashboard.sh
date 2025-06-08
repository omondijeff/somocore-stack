#!/bin/bash

# SomoCore Stack - Dashboard Tests
# This script runs dashboard-specific tests

echo "🎛️ SomoCore Dashboard - Test Suite"
echo "==================================="

# Check if dashboard exists
if [ ! -f "dashboard/package.json" ]; then
    echo "❌ Dashboard package.json not found"
    exit 1
fi

cd dashboard

echo "📦 Setting up dashboard test environment..."

# Install dependencies if needed
if [ ! -d "node_modules" ]; then
    echo "Installing dependencies..."
    npm install
fi

echo ""
echo "🧪 Running dashboard tests..."
echo "============================="

# Check what test scripts are available
if npm run | grep -q " test "; then
    echo "📝 Running Tests:"
    npm run test
else
    echo "⚠️ No test script found"
fi

echo ""
echo "🔍 Linting:"
npm run lint

# Check if type checking is available
if npm run | grep -q "type-check"; then
    echo ""
    echo "📝 Type Checking:"
    npm run type-check
fi

# Check if build works
echo ""
echo "🛠️ Build Test:"
echo "Testing production build..."
npm run build

if [ $? -eq 0 ]; then
    echo "✅ Build successful"
else
    echo "❌ Build failed"
fi

# Run additional test commands if they exist
if npm run | grep -q "test:e2e"; then
    echo ""
    echo "🎭 End-to-End Tests:"
    echo "Note: E2E tests require the backend to be running"
    echo "Run './scripts/start-dev.sh' first, then run E2E tests manually with:"
    echo "cd dashboard && npm run test:e2e"
fi

echo ""
echo "✅ Dashboard testing completed!"

cd .. 