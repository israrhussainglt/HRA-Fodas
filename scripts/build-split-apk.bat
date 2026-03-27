@echo off
REM Build split APKs for HRA-FoDAS (smaller file sizes)

echo ========================================
echo Building HRA-FoDAS Split APKs
echo ========================================
echo.

echo [1/4] Cleaning previous builds...
call flutter clean
echo.

echo [2/4] Getting dependencies...
call flutter pub get
echo.

echo [3/4] Generating app icons...
call dart run flutter_launcher_icons
echo.

echo [4/4] Building split APKs...
call flutter build apk --split-per-abi --release
echo.

echo ========================================
echo Build Complete!
echo ========================================
echo.
echo APK Locations:
echo - build\app\outputs\flutter-apk\app-armeabi-v7a-release.apk (32-bit ARM)
echo - build\app\outputs\flutter-apk\app-arm64-v8a-release.apk (64-bit ARM - Most Common)
echo - build\app\outputs\flutter-apk\app-x86_64-release.apk (64-bit Intel)
echo.
pause
