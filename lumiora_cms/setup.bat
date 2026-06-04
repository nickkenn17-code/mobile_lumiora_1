@echo off
REM Setup script for Lumiora CMS on Windows

echo.
echo ================================================
echo Lumiora CMS - Windows Setup
echo ================================================
echo.

REM Check if Python is installed
python --version >nul 2>&1
if errorlevel 1 (
    echo Error: Python is not installed or not in PATH
    echo Please install Python from https://www.python.org/
    pause
    exit /b 1
)

echo [1/5] Creating virtual environment...
python -m venv venv
if errorlevel 1 (
    echo Error: Failed to create virtual environment
    pause
    exit /b 1
)

echo [2/5] Activating virtual environment...
call venv\Scripts\activate.bat

echo [3/5] Installing dependencies...
pip install -r requirements.txt
if errorlevel 1 (
    echo Error: Failed to install dependencies
    pause
    exit /b 1
)

echo [4/5] Running migrations...
python manage.py makemigrations
python manage.py migrate
if errorlevel 1 (
    echo Error: Failed to run migrations
    pause
    exit /b 1
)

echo [5/5] Running setup script...
python setup.py

echo.
echo ================================================
echo Setup completed successfully!
echo ================================================
echo.
echo To start the development server:
echo   1. Activate the virtual environment:
echo      venv\Scripts\activate
echo   2. Run the server:
echo      python manage.py runserver
echo   3. Visit http://localhost:8000/admin
echo.
pause
