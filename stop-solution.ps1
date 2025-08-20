# FriendShip Solution Process Stopper (PowerShell)
# Останавливает все процессы .NET и Node.js решения

Write-Host "🛑 FriendShip Solution - Остановка всех процессов..." -ForegroundColor Red
Write-Host ""

# Функция для остановки процессов по имени
function Stop-ProcessByName {
    param(
        [string]$ProcessName,
        [string]$Description
    )
    
    Write-Host "[$Description] Остановка процессов $ProcessName..." -ForegroundColor Yellow
    
    try {
        $processes = Get-Process -Name $ProcessName -ErrorAction SilentlyContinue
        if ($processes) {
            $processes | Stop-Process -Force
            Write-Host "✅ $Description остановлены ($($processes.Count) процессов)" -ForegroundColor Green
        } else {
            Write-Host "✅ $Description не найдены или уже остановлены" -ForegroundColor Green
        }
    } catch {
        Write-Host "⚠️  Ошибка при остановке $Description : $($_.Exception.Message)" -ForegroundColor Yellow
    }
}

# Функция для проверки портов
function Test-Ports {
    Write-Host ""
    Write-Host "🔍 Проверка освобождения портов..." -ForegroundColor Cyan
    
    $ports = @(7099, 5173, 7167, 5176, 5250)
    $occupiedPorts = @()
    
    foreach ($port in $ports) {
        $connection = Get-NetTCPConnection -LocalPort $port -ErrorAction SilentlyContinue
        if ($connection) {
            $occupiedPorts += $port
        }
    }
    
    if ($occupiedPorts.Count -eq 0) {
        Write-Host "✅ Все порты освобождены" -ForegroundColor Green
    } else {
        Write-Host "⚠️  Следующие порты все еще заняты: $($occupiedPorts -join ', ')" -ForegroundColor Yellow
        
        foreach ($port in $occupiedPorts) {
            $connection = Get-NetTCPConnection -LocalPort $port -ErrorAction SilentlyContinue
            if ($connection) {
                Write-Host "   Порт $port - PID: $($connection.OwningProcess)" -ForegroundColor Yellow
            }
        }
    }
}

# Основная логика остановки
try {
    Write-Host "🪟 Остановка процессов на Windows..." -ForegroundColor Blue
    
    # 1. Остановка .NET процессов
    Stop-ProcessByName "dotnet" ".NET процессы"
    
    # 2. Остановка Node.js процессов
    Stop-ProcessByName "node" "Node.js процессы"
    
    # 3. Дополнительная остановка по шаблону
    Write-Host ""
    Write-Host "[Дополнительно] Поиск процессов по шаблону..." -ForegroundColor Yellow
    
    # Остановка процессов dotnet run
    $dotnetProcesses = Get-Process | Where-Object { 
        $_.ProcessName -eq "dotnet" -and 
        $_.CommandLine -like "*run*" -ErrorAction SilentlyContinue 
    }
    if ($dotnetProcesses) {
        $dotnetProcesses | Stop-Process -Force
        Write-Host "✅ Дополнительные .NET процессы остановлены" -ForegroundColor Green
    }
    
    # Остановка процессов npm run dev
    $npmProcesses = Get-Process | Where-Object { 
        $_.ProcessName -eq "node" -and 
        $_.CommandLine -like "*npm*" -ErrorAction SilentlyContinue 
    }
    if ($npmProcesses) {
        $npmProcesses | Stop-Process -Force
        Write-Host "✅ Дополнительные Node.js процессы остановлены" -ForegroundColor Green
    }
    
    # 4. Проверка портов
    Start-Sleep -Seconds 2
    Test-Ports
    
    Write-Host ""
    Write-Host "🎯 Все команды остановки выполнены!" -ForegroundColor Green
    Write-Host ""
    Write-Host "💡 Для проверки статуса используйте:" -ForegroundColor Cyan
    Write-Host "   netstat -ano | findstr '7099 5173 7167'" -ForegroundColor White
    Write-Host ""
    Write-Host "🔄 Для перезапуска используйте:" -ForegroundColor Cyan
    Write-Host "   .\start-solution.ps1" -ForegroundColor White
    
} catch {
    Write-Host "❌ Критическая ошибка: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "Нажмите любую клавишу для выхода..." -ForegroundColor Yellow
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
