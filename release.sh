#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

echo "🚀 Starting release build process for Farmers App..."

# Navigate to the frontend directory
cd frontend

echo "📦 Fetching dependencies..."
flutter pub get

echo "🔨 Building the Android APK (Release)..."
flutter build apk --release

# Navigate back to root
cd ..

# Define paths
APK_SOURCE="frontend/build/app/outputs/flutter-apk/app-release.apk"
APK_DEST="farmers_app_v1.0.0.apk"

# Check if the build was successful and the file exists
if [ -f "$APK_SOURCE" ]; then
    echo "✅ Build successful!"
    
    # Move/Copy the APK to the root directory for easy access
    cp "$APK_SOURCE" "$APK_DEST"
    echo "📁 APK copied to: $(pwd)/$APK_DEST"
    
    echo ""
    echo "🎉 Release is ready! You can now distribute $APK_DEST"
else
    echo "❌ Build failed. APK not found at expected path."
    exit 1
fi
