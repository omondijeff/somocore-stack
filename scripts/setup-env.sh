#!/bin/bash

# SomoCore Stack - Environment Setup
# This script sets up the development environment

echo "🛠️ SomoCore Stack - Environment Setup"
echo "======================================"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to print status
print_status() {
    local message=$1
    local status=$2
    
    if [ "$status" = "ok" ]; then
        echo -e "  ${GREEN}✅${NC} $message"
    elif [ "$status" = "warn" ]; then
        echo -e "  ${YELLOW}⚠️${NC} $message"
    elif [ "$status" = "error" ]; then
        echo -e "  ${RED}❌${NC} $message"
    else
        echo -e "  ${BLUE}ℹ️${NC} $message"
    fi
}

echo "🔍 Checking prerequisites..."
echo ""

# Check system requirements
echo "System Requirements:"

# Check Node.js
if command_exists node; then
    NODE_VERSION=$(node --version)
    print_status "Node.js $NODE_VERSION" "ok"
else
    print_status "Node.js not found - Please install Node.js ≥18.0.0" "error"
fi

# Check npm
if command_exists npm; then
    NPM_VERSION=$(npm --version)
    print_status "npm $NPM_VERSION" "ok"
else
    print_status "npm not found" "error"
fi

# Check Docker
if command_exists docker; then
    if docker info > /dev/null 2>&1; then
        DOCKER_VERSION=$(docker --version | cut -d ' ' -f3 | cut -d ',' -f1)
        print_status "Docker $DOCKER_VERSION (running)" "ok"
    else
        print_status "Docker installed but not running" "warn"
    fi
else
    print_status "Docker not found - Please install Docker" "error"
fi

# Check Docker Compose
if command_exists docker-compose; then
    COMPOSE_VERSION=$(docker-compose --version | cut -d ' ' -f3 | cut -d ',' -f1)
    print_status "Docker Compose $COMPOSE_VERSION" "ok"
elif docker compose version > /dev/null 2>&1; then
    COMPOSE_VERSION=$(docker compose version --short)
    print_status "Docker Compose $COMPOSE_VERSION (plugin)" "ok"
else
    print_status "Docker Compose not found" "error"
fi

# Check Git
if command_exists git; then
    GIT_VERSION=$(git --version | cut -d ' ' -f3)
    print_status "Git $GIT_VERSION" "ok"
else
    print_status "Git not found" "error"
fi

# Check Flutter (optional)
if command_exists flutter; then
    FLUTTER_VERSION=$(flutter --version | head -n1 | cut -d ' ' -f2)
    print_status "Flutter $FLUTTER_VERSION (optional)" "ok"
else
    print_status "Flutter not found (optional for mobile development)" "warn"
fi

echo ""
echo "🔧 Setting up project environment..."
echo ""

# Initialize submodules
echo "📦 Git Submodules:"
if [ -f ".gitmodules" ]; then
    print_status "Initializing submodules..." "info"
    git submodule update --init --recursive
    if [ $? -eq 0 ]; then
        print_status "Submodules initialized successfully" "ok"
    else
        print_status "Failed to initialize submodules" "error"
    fi
else
    print_status "No submodules found" "warn"
fi

echo ""
echo "📋 Environment Files:"

# Create environment files from templates
create_env_file() {
    local template=$1
    local target=$2
    local description=$3
    
    if [ -f "$template" ]; then
        if [ ! -f "$target" ]; then
            cp "$template" "$target"
            print_status "Created $target from template" "ok"
        else
            print_status "$target already exists" "warn"
        fi
    else
        print_status "Creating $target ($description)" "info"
        case "$target" in
            ".env")
                cat > "$target" << 'EOF'
# SomoCore Stack - Main Configuration
ENVIRONMENT=development
DOMAIN=localhost
DATABASE_URL=mongodb://localhost:27017/somocore_dev
REDIS_URL=redis://localhost:6379
NODE_ENV=development
EOF
                ;;
            "backend/.env")
                mkdir -p backend
                cat > "$target" << 'EOF'
# SomoCore Backend Configuration
NODE_ENV=development
PORT=3000
MONGODB_URI=mongodb://mongo:27017/somocore_dev
REDIS_URL=redis://redis:6379
JWT_SECRET=your-super-secure-jwt-secret-key-change-in-production
JWT_EXPIRES_IN=7d

# Email Configuration (using MailHog for development)
SMTP_HOST=mailhog
SMTP_PORT=1025
SMTP_USER=
SMTP_PASS=
FROM_EMAIL=noreply@somocore.local

# File Storage (MinIO)
MINIO_ENDPOINT=minio:9000
MINIO_ACCESS_KEY=minioadmin
MINIO_SECRET_KEY=minioadmin
MINIO_BUCKET=somocore-uploads

# Debug
DEBUG=somocore:*
EOF
                ;;
            "dashboard/.env.local")
                mkdir -p dashboard
                cat > "$target" << 'EOF'
# SomoCore Dashboard Configuration
NEXT_PUBLIC_API_URL=http://localhost:3000/api/v1
NEXTAUTH_SECRET=your-super-secure-nextauth-secret-change-in-production
NEXTAUTH_URL=http://localhost:3001

# Development
NODE_ENV=development
EOF
                ;;
        esac
        print_status "Created $target with default values" "ok"
    fi
}

# Create environment files
create_env_file ".env.example" ".env" "Main environment"
create_env_file "backend/.env.example" "backend/.env" "Backend environment"
create_env_file "dashboard/.env.example" "dashboard/.env.local" "Dashboard environment"

echo ""
echo "📦 Installing Dependencies:"

# Install backend dependencies
if [ -f "backend/package.json" ]; then
    print_status "Installing backend dependencies..." "info"
    cd backend
    npm install
    if [ $? -eq 0 ]; then
        print_status "Backend dependencies installed" "ok"
    else
        print_status "Failed to install backend dependencies" "error"
    fi
    cd ..
else
    print_status "Backend package.json not found" "warn"
fi

# Install dashboard dependencies
if [ -f "dashboard/package.json" ]; then
    print_status "Installing dashboard dependencies..." "info"
    cd dashboard
    npm install
    if [ $? -eq 0 ]; then
        print_status "Dashboard dependencies installed" "ok"
    else
        print_status "Failed to install dashboard dependencies" "error"
    fi
    cd ..
else
    print_status "Dashboard package.json not found" "warn"
fi

# Setup Flutter dependencies
if [ -f "mobile/pubspec.yaml" ] && command_exists flutter; then
    print_status "Installing Flutter dependencies..." "info"
    cd mobile
    flutter pub get
    if [ $? -eq 0 ]; then
        print_status "Flutter dependencies installed" "ok"
    else
        print_status "Failed to install Flutter dependencies" "error"
    fi
    cd ..
else
    print_status "Skipping Flutter setup (not available or not needed)" "warn"
fi

echo ""
echo "🎉 Environment Setup Complete!"
echo "=============================="

echo ""
echo "📋 Next Steps:"
echo "  1. Review and update environment files:"
echo "     • .env (main configuration)"
echo "     • backend/.env (backend settings)"
echo "     • dashboard/.env.local (dashboard settings)"
echo ""
echo "  2. Start the development environment:"
echo "     ./scripts/start-dev.sh"
echo ""
echo "  3. Run tests to verify everything works:"
echo "     ./scripts/test-all.sh"
echo ""
echo "🌐 Once started, you can access:"
echo "  • Backend API: http://localhost:3000"
echo "  • Dashboard: http://localhost:3001"
echo "  • API Docs: http://localhost:3000/docs"
echo ""
echo "📚 For more information, see README.md" 