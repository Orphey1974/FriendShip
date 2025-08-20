@echo off
chcp 65001 >nul
echo ========================================
echo    FriendShip Solution HTTPS Setup
echo ========================================
echo.

echo [1/4] Проверка .NET SDK...
dotnet --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ ОШИБКА: .NET SDK не найден!
    echo Установите .NET SDK с https://dotnet.microsoft.com/
    pause
    exit /b 1
)
echo ✅ .NET SDK найден
echo.

echo [2/4] Очистка старых сертификатов...
dotnet dev-certs https --clean >nul 2>&1
if %errorlevel% equ 0 (
    echo ✅ Старые сертификаты очищены
) else (
    echo ⚠️  Ошибка при очистке сертификатов
)
echo.

echo [3/4] Создание нового сертификата...
dotnet dev-certs https --trust >nul 2>&1
if %errorlevel% equ 0 (
    echo ✅ Новый сертификат создан и доверен
) else (
    echo ❌ Ошибка при создании сертификата
    pause
    exit /b 1
)
echo.

echo [4/4] Финальная проверка...
dotnet dev-certs https --check --trust >nul 2>&1
if %errorlevel% equ 0 (
    echo ✅ HTTPS сертификат успешно настроен!
) else (
    echo ❌ Финальная проверка не пройдена
    pause
    exit /b 1
)

echo.
echo ========================================
echo    HTTPS сертификат готов к использованию!
echo ========================================
echo.
echo 💡 Теперь вы можете запустить решение:
echo    .\start-solution.bat
echo    .\start-solution.ps1
echo.
echo 🔐 Сертификат действителен 1 год
echo.
pause
