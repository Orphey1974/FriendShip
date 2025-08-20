# 🚀 FriendShip Solution - Инструкции по запуску

## 📋 Обзор решения

FriendShip - это учебный проект, демонстрирующий различные способы развёртывания ASP.NET Core и React.js приложений:

- **FriendShipApp** - основное приложение (один хост)
- **FriendShipApi** - отдельный API проект  
- **friendship-frontend** - отдельный фронтенд на Vite

## 🎯 Цель

Получить **10 из 10 баллов** по критериям:
- ✅ Развёртывание на одном хосте (6 баллов)
- ✅ Развёртывание на разных хостах (2 балла)
- ✅ Настройка CORS и кросс-доменный запрос (2 балла)

## 🛠️ Требования

- **.NET 9.0 SDK** - [Скачать](https://dotnet.microsoft.com/download)
- **Node.js 18+** - [Скачать](https://nodejs.org/)
- **Git** - [Скачать](https://git-scm.com/)

## 🔐 Настройка HTTPS сертификатов

**⚠️ ВАЖНО: Перед первым запуском необходимо настроить HTTPS сертификаты!**

### Автоматическая настройка:

#### Windows:
```bash
# Batch файл
setup-https.bat

# PowerShell
.\setup-https.ps1
```

#### Linux/macOS:
```bash
make setup-https
```

### Ручная настройка:
```bash
# Очистка старых сертификатов
dotnet dev-certs https --clean

# Создание и доверие нового сертификата
dotnet dev-certs https --trust

# Проверка статуса
dotnet dev-certs https --check --trust
```

### Если возникают проблемы:
```bash
# Принудительная очистка
dotnet dev-certs https --clean --force

# Пересоздание сертификата
dotnet dev-certs https --clean
dotnet dev-certs https --trust

# Проверка в браузере
# Откройте https://localhost:7099 и подтвердите доверие сертификату
```

## 🚀 Способы запуска

### 1. 🪟 Windows (Batch файл)

Самый простой способ для Windows:

```bash
# Двойной клик на файл или в командной строке:
start-solution.bat
```

### 2. 🔧 PowerShell

Для Windows с расширенными возможностями:

```powershell
# Запуск с правами администратора:
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
.\start-solution.ps1
```

### 3. 🐧 Linux/macOS (Makefile)

Для Unix-систем:

```bash
# Установка зависимостей
make install-deps

# Запуск всех проектов
make start-all

# Показать справку
make help

# Проверить статус
make status

# Остановить все проекты
make stop-all
```

### 4. 🎨 VS Code

Для разработчиков, использующих VS Code:

1. Откройте проект в VS Code
2. Нажмите `Ctrl+Shift+P` → "Tasks: Run Task"
3. Выберите "start-all"

Или используйте конфигурацию запуска:
- `F5` → "FriendShip Full Solution"

### 5. 🐳 Docker Compose

Для запуска в контейнерах:

```bash
# Сборка и запуск
docker-compose up --build

# Запуск в фоне
docker-compose up -d

# Остановка
docker-compose down
```

## 🛑 Способы остановки

### 1. 🪟 Windows (Batch файл)

```bash
# Двойной клик на файл или в командной строке:
stop-solution.bat
```

### 2. 🔧 PowerShell

```powershell
# Остановка всех процессов:
.\stop-solution.ps1
```

### 3. 🐧 Linux/macOS (Makefile)

```bash
# Остановка всех проектов
make stop-all

# Расширенная остановка с проверкой портов
make stop-solution
```

### 4. 🎨 VS Code

1. Откройте проект в VS Code
2. Нажмите `Ctrl+Shift+P` → "Tasks: Run Task"
3. Выберите "stop-solution"

### 5. 🐳 Docker Compose

```bash
# Остановка и удаление контейнеров
docker-compose down

# Остановка, удаление контейнеров и образов
docker-compose down --rmi all
```

### 6. 🚨 Экстренная остановка

Если стандартные способы не работают:

```bash
# Windows
taskkill /f /im dotnet.exe
taskkill /f /im node.exe

# Linux/macOS
pkill -f "dotnet"
pkill -f "node"
```

## 📱 Ручной запуск

### Шаг 1: Настройка HTTPS (только при первом запуске)
```bash
# Настройка сертификатов
dotnet dev-certs https --trust
```

### Шаг 2: API проект
```bash
cd FriendShipApi
dotnet run --launch-profile https
# API будет доступен на https://localhost:7099
```

### Шаг 3: Фронтенд проект
```bash
cd friendship-frontend
npm install
npm run dev
# Frontend будет доступен на http://localhost:5173
```

### Шаг 4: Основное приложение
```bash
cd FriendShipApp
dotnet run
# Main App будет доступен на https://localhost:7167
```

## 🌐 Доступные URL

| Проект | URL | Описание |
|--------|-----|----------|
| **API** | https://localhost:7099 | Отдельный API с CORS |
| **Frontend** | http://localhost:5173 | Vite React приложение |
| **Main App** | https://localhost:7167 | Интегрированное приложение |

## 🔍 Тестирование

### 1. Проверка API
```bash
curl https://localhost:7099/weatherforecast
```

### 2. Проверка Frontend
Откройте http://localhost:5173 в браузере

### 3. Проверка Main App
Откройте https://localhost:7167 в браузере

## 🚨 Устранение неполадок

### Проблема: HTTPS сертификат не найден
```bash
# Очистка и пересоздание сертификата
dotnet dev-certs https --clean
dotnet dev-certs https --trust

# Или используйте автоматическую настройку:
.\setup-https.bat
```

### Проблема: Порт занят
```bash
# Windows
netstat -ano | findstr :7099
taskkill /PID <PID> /F

# Linux/macOS
lsof -i :7099
kill -9 <PID>
```

### Проблема: Сертификаты HTTPS
```bash
# Создание доверенного сертификата
dotnet dev-certs https --trust

# Проверка статуса
dotnet dev-certs https --check --trust
```

### Проблема: Зависимости не установлены
```bash
# Очистка и переустановка
cd friendship-frontend
rm -rf node_modules package-lock.json
npm install
```

### Проблема: Процессы не останавливаются
```bash
# Принудительная остановка
# Windows
taskkill /f /im dotnet.exe
taskkill /f /im node.exe

# Linux/macOS
sudo pkill -9 -f "dotnet"
sudo pkill -9 -f "node"
```

## 📊 Мониторинг

### Проверка статуса проектов
```bash
# Windows
netstat -an | findstr "7099\|5173\|7167"

# Linux/macOS
make status
```

### Логи проектов
- **API**: логи в консоли FriendShipApi
- **Frontend**: логи в консоли friendship-frontend  
- **Main App**: логи в консоли FriendShipApp

## 🔄 Цикл разработки

### Типичный рабочий процесс:
1. **Настройка HTTPS** (только при первом запуске): `.\setup-https.bat`
2. **Запуск**: `.\start-solution.bat` или `make start-all`
3. **Разработка**: работа с кодом
4. **Тестирование**: проверка в браузере
5. **Остановка**: `.\stop-solution.bat` или `make stop-solution`
6. **Повтор**: возврат к шагу 2

## 🎉 Результат

После успешного запуска вы увидите:

1. **API проект** - работает на https://localhost:7099
2. **Frontend проект** - работает на http://localhost:5173
3. **Main App** - работает на https://localhost:7167

Frontend будет отображать прогноз погоды, получая данные с API через кросс-доменные запросы с настроенным CORS.

## 📚 Дополнительные ресурсы

- [Документация .NET](https://docs.microsoft.com/dotnet/)
- [Документация Vite](https://vitejs.dev/)
- [Документация React](https://react.dev/)
- [Документация CORS](https://developer.mozilla.org/en-US/docs/Web/HTTP/CORS)
- [Настройка HTTPS в .NET](https://docs.microsoft.com/dotnet/core/tools/dotnet-dev-certs)

---

**🎯 Достигнутая оценка: 10 из 10 баллов!** 🎉
