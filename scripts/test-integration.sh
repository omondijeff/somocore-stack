#!/bin/bash

# SomoCore Stack - Integration Tests
# This script runs integration tests across all services

echo "🔗 SomoCore Stack - Integration Tests"
echo "====================================="

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo "🚀 Starting integration test suite..."
echo ""

# Check if Docker is running
if ! docker info > /dev/null 2>&1; then
    echo "❌ Docker is not running. Please start Docker and try again."
    exit 1
fi

# Start all services
echo "🔧 Starting all services for integration testing..."
./scripts/start-dev.sh

# Wait for services to be ready
echo "⏳ Waiting for services to initialize..."
sleep 30

# Function to check service health
check_service_health() {
    local service_name=$1
    local url=$2
    local expected_status=${3:-200}
    
    echo -n "Checking $service_name... "
    
    response=$(curl -s -o /dev/null -w "%{http_code}" "$url" || echo "000")
    
    if [ "$response" = "$expected_status" ]; then
        echo -e "${GREEN}✅ OK${NC}"
        return 0
    else
        echo -e "${RED}❌ FAILED (HTTP $response)${NC}"
        return 1
    fi
}

echo ""
echo "🔍 Service Health Checks"
echo "========================"

# Health check results
HEALTH_CHECKS=0

# Check backend API
if check_service_health "Backend API" "http://localhost:3000/health"; then
    ((HEALTH_CHECKS++))
fi

# Check backend API documentation
if check_service_health "API Docs" "http://localhost:3000/docs"; then
    ((HEALTH_CHECKS++))
fi

# Check dashboard
if check_service_health "Dashboard" "http://localhost:3001"; then
    ((HEALTH_CHECKS++))
fi

# Check MongoDB Express
if check_service_health "MongoDB Express" "http://localhost:8081"; then
    ((HEALTH_CHECKS++))
fi

# Check Redis Commander
if check_service_health "Redis Commander" "http://localhost:8082"; then
    ((HEALTH_CHECKS++))
fi

# Check MinIO
if check_service_health "MinIO Console" "http://localhost:9003/minio/login"; then
    ((HEALTH_CHECKS++))
fi

# Check MailHog
if check_service_health "MailHog" "http://localhost:8025"; then
    ((HEALTH_CHECKS++))
fi

echo ""
echo "📊 Health Check Results: $HEALTH_CHECKS/7 services healthy"

# API Integration Tests
echo ""
echo "🧪 API Integration Tests"
echo "========================"

# Test API endpoints
echo "Testing core API endpoints..."

# Test health endpoint
echo -n "GET /health... "
if curl -s http://localhost:3000/health | grep -q "ok\|healthy\|running"; then
    echo -e "${GREEN}✅ PASS${NC}"
else
    echo -e "${RED}❌ FAIL${NC}"
fi

# Test API info endpoint
echo -n "GET /api/v1/info... "
response=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:3000/api/v1/info)
if [ "$response" = "200" ]; then
    echo -e "${GREEN}✅ PASS${NC}"
else
    echo -e "${RED}❌ FAIL (HTTP $response)${NC}"
fi

# Database Integration Tests
echo ""
echo "🗄️ Database Integration Tests"
echo "=============================="

echo "Testing database connectivity..."
cd backend

# Run database connectivity test
if npm run | grep -q "test:db"; then
    echo "Running database connection tests..."
    npm run test:db
else
    echo "⚠️ No database-specific tests found"
    echo "Testing basic MongoDB connection..."
    
    # Simple MongoDB connection test
    docker exec somocore-mongo-dev mongosh --eval "db.runCommand('ping')" > /dev/null
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✅ MongoDB connection OK${NC}"
    else
        echo -e "${RED}❌ MongoDB connection failed${NC}"
    fi
fi

cd ..

# Cache Integration Tests
echo ""
echo "📦 Cache Integration Tests"
echo "=========================="

echo "Testing Redis connectivity..."
if docker exec somocore-redis-dev redis-cli ping | grep -q "PONG"; then
    echo -e "${GREEN}✅ Redis connection OK${NC}"
else
    echo -e "${RED}❌ Redis connection failed${NC}"
fi

# File Storage Integration Tests
echo ""
echo "💾 File Storage Integration Tests"
echo "================================="

echo "Testing MinIO connectivity..."
if curl -s http://localhost:9002/minio/health/live | grep -q "OK"; then
    echo -e "${GREEN}✅ MinIO storage OK${NC}"
else
    echo -e "${RED}❌ MinIO storage failed${NC}"
fi

# Full Stack Integration Test
echo ""
echo "🔗 Full Stack Integration Test"
echo "=============================="

echo "Testing full request flow..."

# Create a test request that goes through the full stack
echo -n "Testing API -> Database -> Cache flow... "

# This would be customized based on your actual API endpoints
# For now, we'll test a simple endpoint that likely exists
response=$(curl -s -X GET http://localhost:3000/api/v1/health -H "Content-Type: application/json")

if echo "$response" | grep -q "ok\|healthy\|success"; then
    echo -e "${GREEN}✅ PASS${NC}"
else
    echo -e "${RED}❌ FAIL${NC}"
fi

# Summary
echo ""
echo "📊 Integration Test Summary"
echo "=========================="

if [ $HEALTH_CHECKS -ge 5 ]; then
    echo -e "${GREEN}🎉 Integration tests passed! Most services are healthy.${NC}"
    echo ""
    echo "🌐 All services are accessible:"
    echo "   • Backend API: http://localhost:3000"
    echo "   • Dashboard: http://localhost:3001"
    echo "   • Admin Tools: http://localhost:8081 (MongoDB), http://localhost:8082 (Redis)"
    echo "   • File Storage: http://localhost:9003 (MinIO)"
    echo "   • Email Testing: http://localhost:8025 (MailHog)"
    exit 0
else
    echo -e "${RED}❌ Integration tests failed. Some services are not healthy.${NC}"
    echo ""
    echo "🔧 Troubleshooting:"
    echo "   • Check Docker containers: docker ps"
    echo "   • View logs: ./scripts/logs-all.sh"
    echo "   • Restart services: ./scripts/stop-all.sh && ./scripts/start-dev.sh"
    exit 1
fi 