#!/bin/bash

# SomoCore Stack - Run All Tests
# This script runs tests for all components

echo "🧪 SomoCore Stack - Running All Tests"
echo "====================================="

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Test results tracking
BACKEND_RESULT=0
DASHBOARD_RESULT=0
MOBILE_RESULT=0

echo "🔍 Starting comprehensive test suite..."
echo ""

# Test Backend
if [ -f "backend/package.json" ]; then
    echo "🔧 Testing Backend..."
    echo "--------------------"
    cd backend
    
    # Check if node_modules exists
    if [ ! -d "node_modules" ]; then
        echo "📦 Installing backend dependencies..."
        npm install
    fi
    
    # Run backend tests
    npm test
    BACKEND_RESULT=$?
    
    if [ $BACKEND_RESULT -eq 0 ]; then
        echo -e "${GREEN}✅ Backend tests passed${NC}"
    else
        echo -e "${RED}❌ Backend tests failed${NC}"
    fi
    
    cd ..
    echo ""
else
    echo -e "${YELLOW}⚠️ Backend package.json not found, skipping backend tests${NC}"
    echo ""
fi

# Test Dashboard
if [ -f "dashboard/package.json" ]; then
    echo "🎛️ Testing Dashboard..."
    echo "----------------------"
    cd dashboard
    
    # Check if node_modules exists
    if [ ! -d "node_modules" ]; then
        echo "📦 Installing dashboard dependencies..."
        npm install
    fi
    
    # Run dashboard tests (if test script exists)
    if npm run | grep -q "test"; then
        npm test
        DASHBOARD_RESULT=$?
        
        if [ $DASHBOARD_RESULT -eq 0 ]; then
            echo -e "${GREEN}✅ Dashboard tests passed${NC}"
        else
            echo -e "${RED}❌ Dashboard tests failed${NC}"
        fi
    else
        echo -e "${YELLOW}⚠️ No test script found in dashboard, running lint instead${NC}"
        npm run lint
        DASHBOARD_RESULT=$?
        
        if [ $DASHBOARD_RESULT -eq 0 ]; then
            echo -e "${GREEN}✅ Dashboard lint passed${NC}"
        else
            echo -e "${RED}❌ Dashboard lint failed${NC}"
        fi
    fi
    
    cd ..
    echo ""
else
    echo -e "${YELLOW}⚠️ Dashboard package.json not found, skipping dashboard tests${NC}"
    echo ""
fi

# Test Mobile App
if [ -f "mobile/pubspec.yaml" ]; then
    echo "📱 Testing Mobile App..."
    echo "-----------------------"
    cd mobile
    
    # Check if Flutter is available
    if command -v flutter &> /dev/null; then
        # Get dependencies
        flutter pub get
        
        # Run Flutter tests
        flutter test
        MOBILE_RESULT=$?
        
        if [ $MOBILE_RESULT -eq 0 ]; then
            echo -e "${GREEN}✅ Mobile tests passed${NC}"
        else
            echo -e "${RED}❌ Mobile tests failed${NC}"
        fi
        
        # Run Flutter analyze
        echo "🔍 Running Flutter analysis..."
        flutter analyze
        ANALYZE_RESULT=$?
        
        if [ $ANALYZE_RESULT -eq 0 ]; then
            echo -e "${GREEN}✅ Flutter analysis passed${NC}"
        else
            echo -e "${RED}❌ Flutter analysis failed${NC}"
            MOBILE_RESULT=1
        fi
    else
        echo -e "${YELLOW}⚠️ Flutter not found, skipping mobile tests${NC}"
        echo "   Install Flutter: https://flutter.dev/docs/get-started/install"
    fi
    
    cd ..
    echo ""
else
    echo -e "${YELLOW}⚠️ Mobile pubspec.yaml not found, skipping mobile tests${NC}"
    echo ""
fi

# Test Summary
echo "📊 Test Results Summary"
echo "======================="

if [ $BACKEND_RESULT -eq 0 ]; then
    echo -e "🔧 Backend:   ${GREEN}PASSED${NC}"
else
    echo -e "🔧 Backend:   ${RED}FAILED${NC}"
fi

if [ $DASHBOARD_RESULT -eq 0 ]; then
    echo -e "🎛️ Dashboard: ${GREEN}PASSED${NC}"
else
    echo -e "🎛️ Dashboard: ${RED}FAILED${NC}"
fi

if [ $MOBILE_RESULT -eq 0 ]; then
    echo -e "📱 Mobile:    ${GREEN}PASSED${NC}"
else
    echo -e "📱 Mobile:    ${RED}FAILED${NC}"
fi

echo ""

# Overall result
TOTAL_FAILURES=$((BACKEND_RESULT + DASHBOARD_RESULT + MOBILE_RESULT))

if [ $TOTAL_FAILURES -eq 0 ]; then
    echo -e "${GREEN}🎉 All tests passed successfully!${NC}"
    exit 0
else
    echo -e "${RED}❌ Some tests failed. Please check the output above.${NC}"
    exit 1
fi 