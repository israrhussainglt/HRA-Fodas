@echo off
REM Run code generation for Freezed and JSON Serializable

echo ========================================
echo Running Code Generation
echo ========================================
echo.

echo Generating Freezed and JSON Serializable code...
call dart run build_runner build --delete-conflicting-outputs
echo.

echo ========================================
echo Code Generation Complete!
echo ========================================
echo.
pause
