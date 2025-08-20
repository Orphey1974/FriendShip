@echo off
chcp 65001 >nul
echo ========================================
echo    FriendShip Solution Launcher
echo ========================================
echo.

echo [1/3] Запуск API проекта...
start "FriendShip API" cmd /k "cd FriendShipApi && dotnet run --launch-profile https"
timeout /t 3 /nobreak >nul

echo [2/3] Запуск фронтенд проекта...
start "FriendShip Frontend" cmd /k "cd friendship-frontend && npm run dev"
timeout /t 3 /nobreak >nul

echo [3/3] Запуск основного приложения...
start "FriendShip App" cmd /k "cd FriendShipApp && dotnet run"
timeout /t 3 /nobreak >nul

echo.
echo ========================================
echo    Все проекты запущены!
echo ========================================
echo.
echo API:        https://localhost:7099
echo Frontend:   http://localhost:5173
echo Main App:   https://localhost:7167
echo.
echo Нажмите любую клавишу для выхода...
pause >nul
