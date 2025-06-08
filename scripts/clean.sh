#!/bin/bash

# SomoCore Stack - Clean Environment
# This script cleans up the development environment

echo "🧹 SomoCore Stack - Environment Cleanup"
echo "======================================="

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to ask for confirmation
confirm() {
    read -p "$1 (y/N): " -n 1 -r
    echo
    [[ $RRREPLY =~ ^[Yy]$ ]]
}

echo "This will clean up temporary files, Docker containers, and reset the environment."
echo ""

# Stop all services first
echo "🛑 Stopping all services..."
./scripts/stop-all.sh

echo ""
echo "🧹 Cleanup Options:"
echo "=================="

# Clean Docker containers and volumes
if confirm "Remove Docker containers and volumes?"; then
    echo "🐳 Cleaning Docker environment..."
    
    # Stop and remove containers
    cd backend
    docker-compose -f docker-compose.dev.yml down -v --remove-orphans
    cd ..
    
    # Remove dangling images
    docker image prune -f
    
    # Remove unused volumes
    docker volume prune -f
    
    echo -e "${GREEN}✅ Docker environment cleaned${NC}"
fi

# Clean node_modules
if confirm "Remove node_modules directories?"; then
    echo "📦 Removing node_modules..."
    
    if [ -d "backend/node_modules" ]; then
        rm -rf backend/node_modules
        echo "  Removed backend/node_modules"
    fi
    
    if [ -d "dashboard/node_modules" ]; then
        rm -rf dashboard/node_modules
        echo "  Removed dashboard/node_modules"
    fi
    
    echo -e "${GREEN}✅ Node modules cleaned${NC}"
fi

# Clean build artifacts
if confirm "Remove build artifacts and temporary files?"; then
    echo "🔧 Removing build artifacts..."
    
    # Backend artifacts
    if [ -d "backend/dist" ]; then rm -rf backend/dist; echo "  Removed backend/dist"; fi
    if [ -d "backend/build" ]; then rm -rf backend/build; echo "  Removed backend/build"; fi
    if [ -d "backend/coverage" ]; then rm -rf backend/coverage; echo "  Removed backend/coverage"; fi
    if [ -d "backend/logs" ]; then rm -rf backend/logs; echo "  Removed backend/logs"; fi
    
    # Dashboard artifacts
    if [ -d "dashboard/.next" ]; then rm -rf dashboard/.next; echo "  Removed dashboard/.next"; fi
    if [ -d "dashboard/dist" ]; then rm -rf dashboard/dist; echo "  Removed dashboard/dist"; fi
    if [ -d "dashboard/build" ]; then rm -rf dashboard/build; echo "  Removed dashboard/build"; fi
    if [ -d "dashboard/coverage" ]; then rm -rf dashboard/coverage; echo "  Removed dashboard/coverage"; fi
    
    # Mobile artifacts
    if [ -d "mobile/build" ]; then rm -rf mobile/build; echo "  Removed mobile/build"; fi
    if [ -d "mobile/.dart_tool" ]; then rm -rf mobile/.dart_tool; echo "  Removed mobile/.dart_tool"; fi
    
    # Remove temporary files
    find . -name "*.log" -delete 2>/dev/null
    find . -name ".DS_Store" -delete 2>/dev/null
    find . -name "Thumbs.db" -delete 2>/dev/null
    
    echo -e "${GREEN}✅ Build artifacts cleaned${NC}"
fi

# Clean environment files
if confirm "Remove environment files (.env files)?"; then
    echo "📋 Removing environment files..."
    
    if [ -f ".env" ]; then rm .env; echo "  Removed .env"; fi
    if [ -f "backend/.env" ]; then rm backend/.env; echo "  Removed backend/.env"; fi
    if [ -f "dashboard/.env.local" ]; then rm dashboard/.env.local; echo "  Removed dashboard/.env.local"; fi
    
    echo -e "${YELLOW}⚠️ Environment files removed - you'll need to run setup-env.sh again${NC}"
fi

# Clean package locks (optional - might cause version mismatches)
if confirm "Remove package lock files? (This might cause version mismatches)"; then
    echo "🔒 Removing lock files..."
    
    if [ -f "backend/package-lock.json" ]; then rm backend/package-lock.json; echo "  Removed backend/package-lock.json"; fi
    if [ -f "dashboard/package-lock.json" ]; then rm dashboard/package-lock.json; echo "  Removed dashboard/package-lock.json"; fi
    if [ -f "mobile/pubspec.lock" ]; then rm mobile/pubspec.lock; echo "  Removed mobile/pubspec.lock"; fi
    
    echo -e "${YELLOW}⚠️ Lock files removed - dependencies might install different versions${NC}"
fi

# Full reset option
echo ""
if confirm "Perform a full Git reset? (This will reset submodules and clean Git state)"; then
    echo "🔄 Performing Git reset..."
    
    # Reset main repository
    git clean -fd
    git reset --hard HEAD
    
    # Reset submodules
    git submodule foreach --recursive git clean -fd
    git submodule foreach --recursive git reset --hard HEAD
    git submodule update --init --recursive
    
    echo -e "${GREEN}✅ Git state reset${NC}"
    echo -e "${YELLOW}⚠️ You may need to run setup-env.sh again${NC}"
fi

echo ""
echo "🎉 Cleanup Complete!"
echo "==================="

echo ""
echo "📋 To get back up and running:"
echo "  1. Set up environment: ./scripts/setup-env.sh"
echo "  2. Start services: ./scripts/start-dev.sh"
echo ""
echo "💡 Tip: Use './scripts/clean.sh' anytime you want to start fresh" 