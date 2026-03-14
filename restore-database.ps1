# PostgreSQL Database Restore Script
# Восстанавливает базу данных MPT2512 из бекапа

param(
    [Parameter(Mandatory=$true)]
    [string]$BackupFile
)

$ErrorActionPreference = "Stop"

# Параметры подключения
$DB_HOST = "26.242.232.93"
$DB_PORT = "5432"
$DB_NAME = "MPT2512"
$DB_USER = "postgres"
$DB_PASSWORD = "1"

Write-Host "🔄 Восстановление базы данных из бекапа..." -ForegroundColor Cyan
Write-Host "База: $DB_NAME" -ForegroundColor Yellow
Write-Host "Хост: $DB_HOST" -ForegroundColor Yellow
Write-Host "Файл: $BackupFile" -ForegroundColor Yellow
Write-Host ""

# Проверяем существование файла бекапа
if (-not (Test-Path $BackupFile)) {
    Write-Host "❌ ОШИБКА: Файл бекапа не найден: $BackupFile" -ForegroundColor Red
    exit 1
}

# Устанавливаем переменную окружения для пароля
$env:PGPASSWORD = $DB_PASSWORD

try {
    # Проверяем наличие psql
    $psql = Get-Command psql -ErrorAction SilentlyContinue
    
    if (-not $psql) {
        Write-Host "❌ ОШИБКА: psql не найден!" -ForegroundColor Red
        Write-Host ""
        Write-Host "Установите PostgreSQL клиент:" -ForegroundColor Yellow
        Write-Host "1. Скачайте PostgreSQL с https://www.postgresql.org/download/windows/" -ForegroundColor White
        Write-Host "2. Или установите через Chocolatey: choco install postgresql" -ForegroundColor White
        Write-Host "3. Добавьте путь к psql в PATH (обычно C:\Program Files\PostgreSQL\16\bin)" -ForegroundColor White
        exit 1
    }

    # Предупреждение
    Write-Host "⚠️  ВНИМАНИЕ: Это удалит все текущие данные в базе!" -ForegroundColor Red
    $confirm = Read-Host "Продолжить? (yes/no)"
    
    if ($confirm -ne "yes") {
        Write-Host "Отменено пользователем." -ForegroundColor Yellow
        exit 0
    }

    Write-Host ""
    Write-Host "Восстановление..." -ForegroundColor Cyan

    # Восстанавливаем бекап
    & psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME -f $BackupFile

    if ($LASTEXITCODE -eq 0) {
        Write-Host ""
        Write-Host "✅ База данных успешно восстановлена!" -ForegroundColor Green
    } else {
        Write-Host ""
        Write-Host "❌ Ошибка при восстановлении базы данных!" -ForegroundColor Red
        exit 1
    }
}
catch {
    Write-Host ""
    Write-Host "❌ Ошибка: $_" -ForegroundColor Red
    exit 1
}
finally {
    # Очищаем переменную окружения с паролем
    Remove-Item Env:\PGPASSWORD -ErrorAction SilentlyContinue
}
