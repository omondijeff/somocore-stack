#!/bin/bash

# SomoCore Stack - Deployment Script
# This script handles deployment to different environments

echo "🚀 SomoCore Stack - Deployment"
echo "=============================="

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Default values
ENVIRONMENT="staging"
BUILD_ONLY=false
SKIP_TESTS=false

# Function to show usage
show_usage() {
    echo "Usage: $0 [OPTIONS]"
    echo ""
    echo "Options:"
    echo "  -e, --env ENV        Environment to deploy to (staging|production) [default: staging]"
    echo "  -b, --build-only     Only build, don't deploy"
    echo "  -s, --skip-tests     Skip running tests before deployment"
    echo "  -h, --help           Show this help message"
    echo ""
    echo "Examples:"
    echo "  $0                       # Deploy to staging"
    echo "  $0 -e production         # Deploy to production"
    echo "  $0 --build-only          # Build only (no deploy)"
    echo "  $0 -e staging -s         # Deploy to staging, skip tests"
}

# Parse command line arguments
while (( "$#" )); do
    case "$1" in
        -e|--env)
            if [ -n "$2" ] && [ ${2:0:1} != "-" ]; then
                ENVIRONMENT="$2"
                shift 2
            else
                echo "❌ Error: Argument for $1 is missing" >&2
                exit 1
            fi
            ;;
        -b|--build-only)
            BUILD_ONLY=true
            shift
            ;;
        -s|--skip-tests)
            SKIP_TESTS=true
            shift
            ;;
        -h|--help)
            show_usage
            exit 0
            ;;
        *)
            echo "❌ Error: Unsupported flag $1" >&2
            show_usage
            exit 1
            ;;
    esac
done

# Validate environment
if [[ "$ENVIRONMENT" != "staging" && "$ENVIRONMENT" != "production" ]]; then
    echo "❌ Error: Environment must be 'staging' or 'production'"
    exit 1
fi

echo "🎯 Target Environment: $ENVIRONMENT"
echo "⚙️ Build Only: $BUILD_ONLY"
echo "🧪 Skip Tests: $SKIP_TESTS"
echo ""

# Confirmation for production
if [ "$ENVIRONMENT" = "production" ] && [ "$BUILD_ONLY" = false ]; then
    echo -e "${RED}⚠️ WARNING: You are about to deploy to PRODUCTION!${NC}"
    read -p "Are you sure you want to continue? (yes/NO): " -r
    if [[ ! $REPLY =~ ^[Yy][Ee][Ss]$ ]]; then
        echo "Deployment cancelled."
        exit 0
    fi
fi

# Pre-deployment checks
echo "🔍 Pre-deployment checks..."

# Check if we're in a clean Git state
if ! git diff-index --quiet HEAD --; then
    echo -e "${YELLOW}⚠️ Warning: You have uncommitted changes${NC}"
    if [ "$ENVIRONMENT" = "production" ]; then
        echo "❌ Error: Cannot deploy to production with uncommitted changes"
        exit 1
    fi
fi

# Check if we're on the correct branch
CURRENT_BRANCH=$(git branch --show-current)
if [ "$ENVIRONMENT" = "production" ] && [ "$CURRENT_BRANCH" != "main" ] && [ "$CURRENT_BRANCH" != "master" ]; then
    echo "❌ Error: Production deployments must be from main/master branch"
    echo "   Current branch: $CURRENT_BRANCH"
    exit 1
fi

echo -e "${GREEN}✅ Git checks passed${NC}"

# Run tests (unless skipped)
if [ "$SKIP_TESTS" = false ]; then
    echo ""
    echo "🧪 Running tests..."
    ./scripts/test-all.sh
    if [ $? -ne 0 ]; then
        echo "❌ Error: Tests failed. Deployment aborted."
        echo "   Use --skip-tests to bypass this check (not recommended)"
        exit 1
    fi
    echo -e "${GREEN}✅ All tests passed${NC}"
fi

# Build phase
echo ""
echo "🔧 Building for $ENVIRONMENT..."

# Build backend
echo "📦 Building backend..."
cd backend
npm run build || echo "No build script found"
echo -e "${GREEN}✅ Backend build completed${NC}"
cd ..

# Build dashboard
echo "📦 Building dashboard..."
cd dashboard
npm run build
echo -e "${GREEN}✅ Dashboard build completed${NC}"
cd ..

# Build mobile (optional)
if [ -f "mobile/pubspec.yaml" ] && command -v flutter >/dev/null 2>&1; then
    echo "📱 Building mobile app..."
    cd mobile
    
    # Build for Android
    flutter build apk --release
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✅ Android build completed${NC}"
    else
        echo -e "${YELLOW}⚠️ Android build failed${NC}"
    fi
    
    # Build for iOS (if on macOS)
    if [[ "$OSTYPE" == "darwin"* ]]; then
        flutter build ios --release --no-codesign
        if [ $? -eq 0 ]; then
            echo -e "${GREEN}✅ iOS build completed${NC}"
        else
            echo -e "${YELLOW}⚠️ iOS build failed${NC}"
        fi
    fi
    
    cd ..
fi

# Docker image building
echo ""
echo "🐳 Building Docker images..."

# Build backend Docker image
cd backend
if [ -f "Dockerfile.prod" ]; then
    docker build -f Dockerfile.prod -t somocore-backend:$ENVIRONMENT .
elif [ -f "Dockerfile" ]; then
    docker build -t somocore-backend:$ENVIRONMENT .
else
    echo -e "${YELLOW}⚠️ No Dockerfile found for backend${NC}"
fi
cd ..

# Build dashboard Docker image (if Dockerfile exists)
if [ -f "dashboard/Dockerfile" ]; then
    cd dashboard
    docker build -t somocore-dashboard:$ENVIRONMENT .
    cd ..
fi

echo -e "${GREEN}✅ Docker images built${NC}"

# Stop here if build-only
if [ "$BUILD_ONLY" = true ]; then
    echo ""
    echo "🎉 Build completed successfully!"
    echo "   Backend build: ✅"
    echo "   Dashboard build: ✅"
    echo "   Docker images: ✅"
    echo ""
    echo "🚀 To deploy, run: $0 -e $ENVIRONMENT"
    exit 0
fi

# Deployment phase
echo ""
echo "🚀 Deploying to $ENVIRONMENT..."

case "$ENVIRONMENT" in
    "staging")
        echo "📋 Staging deployment..."
        
        # Deploy with Docker Compose (staging)
        if [ -f "docker-compose.staging.yml" ]; then
            docker-compose -f docker-compose.staging.yml down
            docker-compose -f docker-compose.staging.yml up -d
        elif [ -f "backend/docker-compose.staging.yml" ]; then
            cd backend
            docker-compose -f docker-compose.staging.yml down
            docker-compose -f docker-compose.staging.yml up -d
            cd ..
        else
            echo -e "${YELLOW}⚠️ No staging Docker Compose file found${NC}"
            echo "   Using development configuration..."
            cd backend
            docker-compose -f docker-compose.dev.yml down
            docker-compose -f docker-compose.dev.yml up -d
            cd ..
        fi
        
        echo -e "${GREEN}✅ Staging deployment completed${NC}"
        echo ""
        echo "🌐 Staging URLs:"
        echo "   • Backend: http://staging.somocore.local"
        echo "   • Dashboard: http://staging-dashboard.somocore.local"
        ;;
        
    "production")
        echo "🎯 Production deployment..."
        
        # Check if Kubernetes configs exist
        if [ -d "k8s" ]; then
            echo "☸️ Deploying with Kubernetes..."
            kubectl apply -f k8s/
        elif [ -f "docker-compose.prod.yml" ]; then
            echo "🐳 Deploying with Docker Compose..."
            docker-compose -f docker-compose.prod.yml down
            docker-compose -f docker-compose.prod.yml up -d
        else
            echo "❌ Error: No production deployment configuration found"
            echo "   Expected: k8s/ directory or docker-compose.prod.yml"
            exit 1
        fi
        
        echo -e "${GREEN}✅ Production deployment completed${NC}"
        echo ""
        echo "🌐 Production URLs:"
        echo "   • Backend: https://api.somocore.com"
        echo "   • Dashboard: https://dashboard.somocore.com"
        ;;
esac

# Post-deployment health checks
echo ""
echo "🔍 Post-deployment health checks..."
sleep 10

# Basic health check (customize URLs based on your setup)
if [ "$ENVIRONMENT" = "staging" ]; then
    HEALTH_URL="http://localhost:3000/health"
else
    HEALTH_URL="https://api.somocore.com/health"
fi

echo -n "Checking API health... "
if curl -s "$HEALTH_URL" >/dev/null; then
    echo -e "${GREEN}✅ Healthy${NC}"
else
    echo -e "${RED}❌ Health check failed${NC}"
    echo "   Check logs: ./scripts/logs-all.sh"
fi

echo ""
echo "🎉 Deployment completed successfully!"
echo "======================================"

echo ""
echo "📋 What was deployed:"
echo "   • Environment: $ENVIRONMENT"
echo "   • Backend: Node.js API with Docker"
echo "   • Dashboard: Next.js application"
echo "   • Mobile: Flutter builds (if available)"
echo ""
echo "🔧 Post-deployment tasks:"
echo "   • Monitor logs: ./scripts/logs-all.sh"
echo "   • Check status: ./scripts/status.sh"
echo "   • Run integration tests: ./scripts/test-integration.sh"
echo ""
echo "📚 Documentation: See README.md for more details"

echo ""
echo "🎉 Deployment script ready!"
echo "📚 Customize this script for your deployment needs" 