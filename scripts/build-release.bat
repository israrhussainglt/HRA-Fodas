@echo off
REM Build release APK for HRA-FoDAS

echo ========================================
echo Building HRA-FoDAS Release APK
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

echo [4/4] Building release APK...
call flutter build apk --release
echo.

echo ========================================
echo Build Complete!
echo ========================================
echo.
echo APK Location: build\app\outputs\flutter-apk\app-release.apk
echo.
pause
