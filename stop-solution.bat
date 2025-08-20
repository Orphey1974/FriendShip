@echo off
echo ========================================
echo    FriendShip Solution Stopper
echo ========================================
echo.

echo [1/3] Остановка .NET процессов...
taskkill /f /im dotnet.exe >nul 2>&1
if %errorlevel% equ 0 (
    echo ✓ .NET процессы остановлены
) else (
    echo ✓ .NET процессы не найдены или уже остановлены
)

echo [2/3] Остановка Node.js процессов...
taskkill /f /im node.exe >nul 2>&1
if %errorlevel% equ 0 (
    echo ✓ Node.js процессы остановлены
) else (
    echo ✓ Node.js процессы не найдены или уже остановлены
)

echo [3/3] Проверка портов...
echo.

set "ports_free=true"

netstat -ano | findstr ":7099" >nul 2>&1
if %errorlevel% equ 0 (
    echo ⚠️  Порт 7099 все еще занят
    set "ports_free=false"
) else (
    echo ✓ Порт 7099 свободен
)

netstat -ano | findstr ":5173" >nul 2>&1
if %errorlevel% equ 0 (
    echo ⚠️  Порт 5173 все еще занят
    set "ports_free=false"
) else (
    echo ✓ Порт 5173 свободен
)

netstat -ano | findstr ":7167" >nul 2>&1
if %errorlevel% equ 0 (
    echo ⚠️  Порт 7167 все еще занят
    set "ports_free=false"
) else (
    echo ✓ Порт 7167 свободен
)

echo.
if "%ports_free%"=="true" (
    echo ========================================
    echo    Все процессы остановлены!
    echo ========================================
) else (
    echo ========================================
    echo    Процессы остановлены, но некоторые
    echo    порты могут быть заняты
    echo ========================================
)

echo.
echo 💡 Для перезапуска используйте: start-solution.bat
echo.
pause
