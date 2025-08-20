# FriendShip Solution Makefile
# Команды для запуска всех проектов

.PHONY: help start-api start-frontend start-main start-all stop-all clean stop-solution setup-https

# Цвета для вывода
GREEN = \033[0;32m
YELLOW = \033[1;33m
BLUE = \033[0;34m
RED = \033[0;31m
NC = \033[0m # No Color

help: ## Показать справку по командам
	@echo "$(BLUE)========================================"
	@echo "    FriendShip Solution Commands"
	@echo "========================================$(NC)"
	@echo ""
	@echo "$(GREEN)Доступные команды:$(NC)"
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "  $(YELLOW)%-15s$(NC) %s\n", $$1, $$2}' $(MAKEFILE_LIST)
	@echo ""
	@echo "$(GREEN)Порты:$(NC)"
	@echo "  API:        https://localhost:7099"
	@echo "  Frontend:   http://localhost:5173"
	@echo "  Main App:   https://localhost:7167"

setup-https: ## Настроить HTTPS сертификаты для разработки
	@echo "$(YELLOW)🔐 Настройка HTTPS сертификатов...$(NC)"
	@dotnet dev-certs https --clean || true
	@dotnet dev-certs https --trust
	@echo "$(GREEN)✅ HTTPS сертификаты настроены$(NC)"

start-api: ## Запустить API проект
	@echo "$(YELLOW)[1/3] Запуск API проекта...$(NC)"
	@cd FriendShipApi && dotnet run --launch-profile https &
	@echo "$(GREEN)✓ API запущен на https://localhost:7099$(NC)"

start-frontend: ## Запустить фронтенд проект
	@echo "$(YELLOW)[2/3] Запуск фронтенд проекта...$(NC)"
	@cd friendship-frontend && npm run dev &
	@echo "$(GREEN)✓ Frontend запущен на http://localhost:5173$(NC)"

start-main: ## Запустить основное приложение
	@echo "$(YELLOW)[3/3] Запуск основного приложения...$(NC)"
	@cd FriendShipApp && dotnet run &
	@echo "$(GREEN)✓ Main App запущен на https://localhost:7167$(NC)"

start-all: ## Запустить все проекты
	@echo "$(BLUE)========================================"
	@echo "    Запуск FriendShip Solution"
	@echo "========================================$(NC)"
	@echo ""
	$(MAKE) start-api
	@sleep 3
	$(MAKE) start-frontend
	@sleep 3
	$(MAKE) start-main
	@sleep 3
	@echo ""
	@echo "$(GREEN)========================================"
	@echo "    Все проекты запущены!"
	@echo "========================================$(NC)"
	@echo ""
	@echo "$(GREEN)✓ API:        https://localhost:7099$(NC)"
	@echo "$(GREEN)✓ Frontend:   http://localhost:5173$(NC)"
	@echo "$(GREEN)✓ Main App:   https://localhost:7167$(NC)"
	@echo ""
	@echo "$(YELLOW)Для остановки всех проектов выполните: make stop-all$(NC)"

stop-all: ## Остановить все проекты
	@echo "$(RED)Остановка всех проектов...$(NC)"
	@pkill -f "dotnet run" || true
	@pkill -f "npm run dev" || true
	@echo "$(GREEN)✓ Все проекты остановлены$(NC)"

stop-solution: ## Остановить все процессы решения (расширенная остановка)
	@echo "$(RED)🛑 Остановка всех процессов FriendShip Solution...$(NC)"
	@echo "$(YELLOW)[1/3] Остановка .NET процессов...$(NC)"
	@pkill -f "dotnet" || true
	@echo "$(YELLOW)[2/3] Остановка Node.js процессов...$(NC)"
	@pkill -f "node" || true
	@echo "$(YELLOW)[3/3] Проверка портов...$(NC)"
	@if curl -s http://localhost:7099 > /dev/null 2>&1; then echo "$(RED)⚠️  Порт 7099 все еще занят"; else echo "$(GREEN)✓ Порт 7099 свободен"; fi
	@if curl -s http://localhost:5173 > /dev/null 2>&1; then echo "$(RED)⚠️  Порт 5173 все еще занят"; else echo "$(GREEN)✓ Порт 5173 свободен"; fi
	@if curl -s http://localhost:7167 > /dev/null 2>&1; then echo "$(RED)⚠️  Порт 7167 все еще занят"; else echo "$(GREEN)✓ Порт 7167 свободен"; fi
	@echo "$(GREEN)✅ Все процессы остановлены$(NC)"

clean: ## Очистить временные файлы
	@echo "$(YELLOW)Очистка временных файлов...$(NC)"
	@cd FriendShipApi && dotnet clean
	@cd FriendShipApp && dotnet clean
	@cd friendship-frontend && rm -rf node_modules package-lock.json
	@echo "$(GREEN)✓ Временные файлы очищены$(NC)"

install-deps: ## Установить зависимости
	@echo "$(YELLOW)Установка зависимостей...$(NC)"
	@cd friendship-frontend && npm install
	@echo "$(GREEN)✓ Зависимости установлены$(NC)"

status: ## Показать статус проектов
	@echo "$(BLUE)Статус проектов:$(NC)"
	@echo -n "API (7099): "
	@if curl -s https://localhost:7099/weatherforecast > /dev/null 2>&1; then echo "$(GREEN)✓ Работает$(NC)"; else echo "$(RED)✗ Не работает$(NC)"; fi
	@echo -n "Frontend (5173): "
	@if curl -s http://localhost:5173 > /dev/null 2>&1; then echo "$(GREEN)✓ Работает$(NC)"; else echo "$(RED)✗ Не работает$(NC)"; fi
	@echo -n "Main App (7167): "
	@if curl -s https://localhost:7167 > /dev/null 2>&1; then echo "$(GREEN)✓ Работает$(NC)"; else echo "$(RED)✗ Не работает$(NC)"; fi
