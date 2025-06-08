#!/bin/bash

# SomoCore Stack - System Status
# This script checks the status of all services

echo "📊 SomoCore Stack - System Status"
echo "=================================="

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to check service status
check_service() {
    local name=$1
    local url=$2
    local expected_status=${3:-200}
    
    echo -n "  $name: "
    
    if command -v curl >/dev/null 2>&1; then
        response=$(curl -s -o /dev/null -w "%{http_code}" "$url" 2>/dev/null || echo "000")
        
        if [ "$response" = "$expected_status" ]; then
            echo -e "${GREEN}✅ Running (HTTP $response)${NC}"
            return 0
        elif [ "$response" = "000" ]; then
            echo -e "${RED}❌ Not accessible${NC}"
            return 1
        else
            echo -e "${YELLOW}⚠️ Unexpected response (HTTP $response)${NC}"
            return 1
        fi
    else
        echo -e "${YELLOW}⚠️ curl not available - cannot check${NC}"
        return 1
    fi
}

# Function to check Docker container
check_container() {
    local name=$1
    local container_name=$2
    
    echo -n "  $name: "
    
    if docker ps --format "table {{.Names}}" | grep -q "^$container_name$"; then
        status=$(docker inspect --format='{{.State.Status}}' "$container_name" 2>/dev/null)
        if [ "$status" = "running" ]; then
            echo -e "${GREEN}✅ Running${NC}"
            return 0
        else
            echo -e "${RED}❌ Stopped ($status)${NC}"
            return 1
        fi
    else
        echo -e "${RED}❌ Not found${NC}"
        return 1
    fi
}

# Function to check process
check_process() {
    local name=$1
    local process_pattern=$2
    
    echo -n "  $name: "
    
    if pgrep -f "$process_pattern" > /dev/null; then
        echo -e "${GREEN}✅ Running${NC}"
        return 0
    else
        echo -e "${RED}❌ Not running${NC}"
        return 1
    fi
}

echo ""
echo "🔍 System Prerequisites:"

# Check Docker
echo -n "  Docker: "
if command -v docker >/dev/null 2>&1; then
    if docker info > /dev/null 2>&1; then
        version=$(docker --version | cut -d ' ' -f3 | cut -d ',' -f1)
        echo -e "${GREEN}✅ Running ($version)${NC}"
    else
        echo -e "${RED}❌ Not running${NC}"
    fi
else
    echo -e "${RED}❌ Not installed${NC}"
fi

# Check Node.js
echo -n "  Node.js: "
if command -v node >/dev/null 2>&1; then
    version=$(node --version)
    echo -e "${GREEN}✅ Available ($version)${NC}"
else
    echo -e "${RED}❌ Not available${NC}"
fi

# Check Flutter
echo -n "  Flutter: "
if command -v flutter >/dev/null 2>&1; then
    version=$(flutter --version 2>/dev/null | head -n1 | cut -d ' ' -f2)
    echo -e "${GREEN}✅ Available ($version)${NC}"
else
    echo -e "${YELLOW}⚠️ Not available (optional)${NC}"
fi

echo ""
echo "🐳 Docker Services:"

# Check Docker containers
check_container "Backend API" "somocore-app-dev"
check_container "MongoDB" "somocore-mongo-dev"
check_container "Redis" "somocore-redis-dev"
check_container "Nginx" "somocore-nginx-dev"
check_container "MongoDB Express" "somocore-mongo-express-dev"
check_container "Redis Commander" "somocore-redis-commander-dev"
check_container "MinIO" "somocore-minio-dev"
check_container "MailHog" "somocore-mailhog-dev"

echo ""
echo "🌐 Web Services:"

# Check web services
check_service "Backend API" "http://localhost:3000/health"
check_service "Dashboard" "http://localhost:3001"
check_service "API Documentation" "http://localhost:3000/docs"
check_service "MongoDB Express" "http://localhost:8081"
check_service "Redis Commander" "http://localhost:8082"
check_service "MinIO Console" "http://localhost:9003/minio/health/live"
check_service "MailHog Web" "http://localhost:8025"

echo ""
echo "📱 Local Processes:"

# Check local processes
check_process "Dashboard (Next.js)" "next dev"

echo ""
echo "📊 Resource Usage:"

# Docker container resource usage
if command -v docker >/dev/null 2>&1 && docker info > /dev/null 2>&1; then
    echo "  Docker Container Stats:"
    docker stats --no-stream --format "table {{.Name}}\t{{.CPUPerc}}\t{{.MemUsage}}" | grep somocore || echo "    No SomoCore containers running"
else
    echo "  Docker not available for stats"
fi

echo ""
echo "💾 Storage Status:"

# Check disk usage
echo "  Disk Usage:"
df -h . 2>/dev/null | tail -1 | awk '{print "    Available: " $4 " (" $5 " used)"}'

# Docker volume usage
if command -v docker >/dev/null 2>&1 && docker info > /dev/null 2>&1; then
    echo "  Docker Volumes:"
    docker system df --format "table {{.Type}}\t{{.Total}}\t{{.Size}}\t{{.Reclaimable}}" 2>/dev/null | grep -E "(VOLUMES|Local)" || echo "    No volume info available"
fi

echo ""
echo "🔗 Network Status:"

# Check if ports are in use
echo "  Port Usage:"
check_port() {
    local port=$1
    local service=$2
    
    if lsof -i :$port >/dev/null 2>&1 || netstat -an 2>/dev/null | grep ":$port " | grep -q LISTEN; then
        echo -e "    Port $port: ${GREEN}✅ In use ($service)${NC}"
    else
        echo -e "    Port $port: ${RED}❌ Free ($service not running)${NC}"
    fi
}

check_port "3000" "Backend API"
check_port "3001" "Dashboard"
check_port "27017" "MongoDB"
check_port "6379" "Redis"
check_port "8081" "MongoDB Express"
check_port "8082" "Redis Commander"
check_port "9002" "MinIO API"
check_port "9003" "MinIO Console"
check_port "8025" "MailHog"

echo ""
echo "📋 Quick Actions:"
echo "  • Start all services: ./scripts/start-all.sh"
echo "  • Start development: ./scripts/start-dev.sh"
echo "  • View logs: ./scripts/logs-all.sh"
echo "  • Run tests: ./scripts/test-all.sh"
echo "  • Stop services: ./scripts/stop-all.sh"
echo "  • Clean environment: ./scripts/clean.sh"

echo ""
echo "📚 Documentation: README.md" 