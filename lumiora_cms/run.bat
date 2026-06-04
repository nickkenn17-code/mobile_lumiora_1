@echo off
REM Run development server for Lumiora CMS

if not exist "venv\" (
    echo Virtual environment not found. Running setup first...
    call setup.bat
)

echo Activating virtual environment...
call venv\Scripts\activate.bat

echo Starting Django development server...
echo Visit http://localhost:8000/admin in your browser
echo.
python manage.py runserver

pause
