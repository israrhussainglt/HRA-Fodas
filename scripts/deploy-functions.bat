@echo off
REM Deploy Appwrite Functions for HRA-FoDAS

echo ========================================
echo Deploying Appwrite Functions
echo ========================================
echo.

echo [1/2] Deploying donation-events function...
cd functions\donation-events
call appwrite deploy function
cd ..\..
echo.

echo [2/2] Deploying notification-sender function...
cd functions\notification-sender
call appwrite deploy function
cd ..\..
echo.

echo ========================================
echo Deployment Complete!
echo ========================================
echo.
pause
