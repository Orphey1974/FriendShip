# FriendShip Solution Launcher (PowerShell)
# Запуск всех проектов решения

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "    FriendShip Solution Launcher" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Функция для запуска проекта в новом окне
function Start-ProjectInNewWindow {
    param(
        [string]$ProjectName,
        [string]$Command,
        [string]$WorkingDirectory
    )
    
    Write-Host "[$ProjectName] Запуск..." -ForegroundColor Yellow
    Start-Process powershell -ArgumentList "-NoExit", "-Command", "cd '$WorkingDirectory'; $Command" -WindowStyle Normal
    Start-Sleep -Seconds 3
}

try {
    # Проверяем наличие .NET
    if (-not (Get-Command dotnet -ErrorAction SilentlyContinue)) {
        Write-Host "ОШИБКА: .NET SDK не найден!" -ForegroundColor Red
        Write-Host "Установите .NET SDK с https://dotnet.microsoft.com/" -ForegroundColor Red
        exit 1
    }
    
    # Проверяем наличие Node.js
    if (-not (Get-Command node -ErrorAction SilentlyContinue)) {
        Write-Host "ОШИБКА: Node.js не найден!" -ForegroundColor Red
        Write-Host "Установите Node.js с https://nodejs.org/" -ForegroundColor Red
        exit 1
    }
    
    Write-Host "Запуск проектов..." -ForegroundColor Green
    
    # 1. API проект
    Start-ProjectInNewWindow "1/3 - API" "dotnet run --launch-profile https" "FriendShipApi"
    
    # 2. Фронтенд проект
    Start-ProjectInNewWindow "2/3 - Frontend" "npm run dev" "friendship-frontend"
    
    # 3. Основное приложение
    Start-ProjectInNewWindow "3/3 - Main App" "dotnet run" "FriendShipApp"
    
    Write-Host ""
    Write-Host "========================================" -ForegroundColor Green
    Write-Host "    Все проекты запущены!" -ForegroundColor Green
    Write-Host "========================================" -ForegroundColor Green
    Write-Host ""
    Write-Host "API:        https://localhost:7099" -ForegroundColor White
    Write-Host "Frontend:   http://localhost:5173" -ForegroundColor White
    Write-Host "Main App:   https://localhost:7167" -ForegroundColor White
    Write-Host ""
    Write-Host "Нажмите любую клавишу для выхода..." -ForegroundColor Yellow
    
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    
} catch {
    Write-Host "Ошибка при запуске: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host "Нажмите любую клавишу для выхода..." -ForegroundColor Yellow
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
}
