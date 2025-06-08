#!/bin/bash

# SomoCore Stack - Mobile App Tests
# This script runs Flutter mobile app tests

echo "📱 SomoCore Mobile - Test Suite"
echo "==============================="

# Check if mobile app exists
if [ ! -f "mobile/pubspec.yaml" ]; then
    echo "❌ Mobile pubspec.yaml not found"
    exit 1
fi

# Check if Flutter is installed
if ! command -v flutter &> /dev/null; then
    echo "❌ Flutter is not installed or not in PATH"
    echo "   Please install Flutter: https://flutter.dev/docs/get-started/install"
    exit 1
fi

cd mobile

echo "📦 Setting up mobile test environment..."

# Get Flutter dependencies
flutter pub get

echo ""
echo "🧪 Running mobile tests..."
echo "=========================="

# Run Flutter tests
echo "📝 Unit & Widget Tests:"
flutter test

echo ""
echo "🔍 Code Analysis:"
flutter analyze

echo ""
echo "📋 Dependency Check:"
flutter pub deps

# Run additional Flutter commands
echo ""
echo "🛠️ Build Validation:"
echo "Checking if app builds successfully..."

# Test build for Android (debug)
echo "🤖 Testing Android build..."
flutter build apk --debug --quiet

if [ $? -eq 0 ]; then
    echo "✅ Android build successful"
else
    echo "❌ Android build failed"
fi

# Test build for iOS (if on macOS)
if [[ "$OSTYPE" == "darwin"* ]]; then
    echo "🍎 Testing iOS build..."
    flutter build ios --debug --no-codesign --quiet
    
    if [ $? -eq 0 ]; then
        echo "✅ iOS build successful"
    else
        echo "❌ iOS build failed"
    fi
else
    echo "⚠️ iOS build skipped (not on macOS)"
fi

echo ""
echo "✅ Mobile testing completed!"

cd .. 