# FriendShip Solution HTTPS Setup (PowerShell)
# Настройка HTTPS сертификатов для разработки

# Устанавливаем кодировку UTF-8
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$OutputEncoding = [System.Text.Encoding]::UTF8

Write-Host "🔐 FriendShip Solution - Настройка HTTPS сертификатов..." -ForegroundColor Cyan
Write-Host ""

try {
    # Проверяем наличие .NET
    if (-not (Get-Command dotnet -ErrorAction SilentlyContinue)) {
        Write-Host "❌ ОШИБКА: .NET SDK не найден!" -ForegroundColor Red
        Write-Host "Установите .NET SDK с https://dotnet.microsoft.com/" -ForegroundColor Red
        exit 1
    }
    
    Write-Host "✅ .NET SDK найден" -ForegroundColor Green
    Write-Host ""
    
    # Шаг 1: Проверяем текущий статус сертификата
    Write-Host "🔍 Шаг 1: Проверка текущего статуса сертификата..." -ForegroundColor Yellow
    $certCheck = dotnet dev-certs https --check 2>&1
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✅ Сертификат найден и действителен" -ForegroundColor Green
        Write-Host $certCheck -ForegroundColor Gray
    } else {
        Write-Host "⚠️  Сертификат не найден или недействителен" -ForegroundColor Yellow
    }
    
    Write-Host ""
    
    # Шаг 2: Очищаем старые сертификаты
    Write-Host "🧹 Шаг 2: Очистка старых сертификатов..." -ForegroundColor Yellow
    $cleanResult = dotnet dev-certs https --clean 2>&1
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✅ Старые сертификаты очищены" -ForegroundColor Green
    } else {
        Write-Host "⚠️  Ошибка при очистке сертификатов: $cleanResult" -ForegroundColor Yellow
    }
    
    Write-Host ""
    
    # Шаг 3: Создаем новый сертификат
    Write-Host "🔑 Шаг 3: Создание нового сертификата..." -ForegroundColor Yellow
    $createResult = dotnet dev-certs https --trust 2>&1
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✅ Новый сертификат создан и доверен" -ForegroundColor Green
    } else {
        Write-Host "❌ Ошибка при создании сертификата: $createResult" -ForegroundColor Red
        exit 1
    }
    
    Write-Host ""
    
    # Шаг 4: Финальная проверка
    Write-Host "✅ Шаг 4: Финальная проверка сертификата..." -ForegroundColor Yellow
    $finalCheck = dotnet dev-certs https --check --trust 2>&1
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "🎉 HTTPS сертификат успешно настроен!" -ForegroundColor Green
        Write-Host $finalCheck -ForegroundColor Gray
    } else {
        Write-Host "❌ Финальная проверка не пройдена" -ForegroundColor Red
        exit 1
    }
    
    Write-Host ""
    Write-Host "========================================" -ForegroundColor Green
    Write-Host "    HTTPS сертификат готов к использованию!"
    Write-Host "========================================" -ForegroundColor Green
    Write-Host ""
    Write-Host "💡 Теперь вы можете запустить решение:" -ForegroundColor Cyan
    Write-Host "   .\start-solution.bat" -ForegroundColor White
    Write-Host "   .\start-solution.ps1" -ForegroundColor White
    Write-Host ""
    Write-Host "🔐 Сертификат действителен до: $((Get-Date).AddYears(1).ToString('yyyy-MM-dd'))" -ForegroundColor Cyan
    
} catch {
    Write-Host "❌ Критическая ошибка: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "Нажмите любую клавишу для выхода..." -ForegroundColor Yellow
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
