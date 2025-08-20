#!/usr/bin/env node

/**
 * FriendShip Solution Process Stopper
 * Останавливает все процессы .NET и Node.js решения
 */

const { exec } = require('child_process');
const os = require('os');

console.log('🛑 FriendShip Solution - Остановка всех процессов...\n');

const platform = os.platform();

function stopProcesses() {
    if (platform === 'win32') {
        // Windows
        console.log('🪟 Остановка процессов на Windows...');
        
        // Остановка .NET процессов
        exec('taskkill /f /im dotnet.exe', (error, stdout, stderr) => {
            if (error) {
                if (error.code === 1) {
                    console.log('✅ .NET процессы не найдены или уже остановлены');
                } else {
                    console.log(`⚠️  Ошибка при остановке .NET процессов: ${error.message}`);
                }
            } else {
                console.log('✅ .NET процессы остановлены');
            }
        });
        
        // Остановка Node.js процессов
        exec('taskkill /f /im node.exe', (error, stdout, stderr) => {
            if (error) {
                if (error.code === 1) {
                    console.log('✅ Node.js процессы не найдены или уже остановлены');
                } else {
                    console.log(`⚠️  Ошибка при остановке Node.js процессов: ${error.message}`);
                }
            } else {
                console.log('✅ Node.js процессы остановлены');
            }
        });
        
        // Проверка портов
        setTimeout(() => {
            console.log('\n🔍 Проверка освобождения портов...');
            exec('netstat -ano | findstr "7099 5173 7167 5176 5250"', (error, stdout, stderr) => {
                if (error || !stdout) {
                    console.log('✅ Все порты освобождены');
                } else {
                    console.log('⚠️  Некоторые порты все еще заняты:');
                    console.log(stdout);
                }
            });
        }, 2000);
        
    } else {
        // Linux/macOS
        console.log('🐧 Остановка процессов на Unix-системе...');
        
        // Остановка .NET процессов
        exec('pkill -f "dotnet run"', (error, stdout, stderr) => {
            if (error) {
                if (error.code === 1) {
                    console.log('✅ .NET процессы не найдены или уже остановлены');
                } else {
                    console.log(`⚠️  Ошибка при остановке .NET процессов: ${error.message}`);
                }
            } else {
                console.log('✅ .NET процессы остановлены');
            }
        });
        
        // Остановка Node.js процессов
        exec('pkill -f "npm run dev"', (error, stdout, stderr) => {
            if (error) {
                if (error.code === 1) {
                    console.log('✅ Node.js процессы не найдены или уже остановлены');
                } else {
                    console.log(`⚠️  Ошибка при остановке Node.js процессов: ${error.message}`);
                }
            } else {
                console.log('✅ Node.js процессы остановлены');
            }
        });
        
        // Проверка портов
        setTimeout(() => {
            console.log('\n🔍 Проверка освобождения портов...');
            exec('lsof -i :7099,:5173,:7167,:5176,:5250', (error, stdout, stderr) => {
                if (error || !stdout) {
                    console.log('✅ Все порты освобождены');
                } else {
                    console.log('⚠️  Некоторые порты все еще заняты:');
                    console.log(stdout);
                }
            });
        }, 2000);
    }
}

// Основная функция
function main() {
    try {
        stopProcesses();
        
        console.log('\n🎯 Все команды остановки выполнены!');
        console.log('💡 Для проверки статуса используйте:');
        if (platform === 'win32') {
            console.log('   netstat -ano | findstr "7099 5173 7167"');
        } else {
            console.log('   lsof -i :7099,:5173,:7167');
        }
        
    } catch (error) {
        console.error('❌ Критическая ошибка:', error.message);
        process.exit(1);
    }
}

// Запуск
main();
