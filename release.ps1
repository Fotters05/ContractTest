# Скрипт для создания нового релиза Contract2512
# Автоматически обновляет версию, создает тег и пушит на GitHub

param(
    [Parameter(Mandatory=$true)]
    [string]$Version,
    
    [Parameter(Mandatory=$false)]
    [string]$Message = "Release v$Version"
)

Write-Host "Создание релиза v$Version" -ForegroundColor Cyan
Write-Host ""

# 1. Проверяем формат версии
if ($Version -notmatch '^\d+\.\d+\.\d+$') {
    Write-Host "Неверный формат версии! Используйте формат: 1.0.0" -ForegroundColor Red
    exit 1
}

# 2. Обновляем версию в Contract2512.csproj
Write-Host "Обновление версии в Contract2512.csproj..." -ForegroundColor Yellow

$csprojPath = "Contract2512.csproj"
$csprojContent = Get-Content $csprojPath -Raw

# Обновляем все версии
$csprojContent = $csprojContent -replace '<Version>[\d\.]+</Version>', "<Version>$Version</Version>"
$csprojContent = $csprojContent -replace '<AssemblyVersion>[\d\.]+</AssemblyVersion>', "<AssemblyVersion>$Version.0</AssemblyVersion>"
$csprojContent = $csprojContent -replace '<FileVersion>[\d\.]+</FileVersion>', "<FileVersion>$Version.0</FileVersion>"

Set-Content $csprojPath $csprojContent -NoNewline

Write-Host "Версия обновлена: $Version" -ForegroundColor Green
Write-Host ""

# 3. Проверяем, есть ли изменения
Write-Host "Проверка изменений..." -ForegroundColor Yellow
$status = git status --porcelain
if ([string]::IsNullOrWhiteSpace($status)) {
    Write-Host "Нет изменений для коммита" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Хотите создать тег для текущей версии? (y/n)" -ForegroundColor Cyan
    $response = Read-Host
    if ($response -ne 'y') {
        Write-Host "Отменено" -ForegroundColor Red
        exit 1
    }
} else {
    # 4. Делаем commit
    Write-Host "Создание коммита..." -ForegroundColor Yellow
    git add .
    git commit -m $Message
    Write-Host "Коммит создан" -ForegroundColor Green
    Write-Host ""
}

# 5. Создаем тег
Write-Host "Создание тега v$Version..." -ForegroundColor Yellow
$tagExists = git tag -l "v$Version"
if ($tagExists) {
    Write-Host "Тег v$Version уже существует!" -ForegroundColor Yellow
    Write-Host "Хотите удалить старый тег и создать новый? (y/n)" -ForegroundColor Cyan
    $response = Read-Host
    if ($response -eq 'y') {
        git tag -d "v$Version"
        git push origin --delete "v$Version" 2>$null
        Write-Host "Старый тег удален" -ForegroundColor Green
    } else {
        Write-Host "Отменено" -ForegroundColor Red
        exit 1
    }
}

git tag "v$Version"
Write-Host "Тег создан: v$Version" -ForegroundColor Green
Write-Host ""

# 6. Пушим на GitHub
Write-Host "Отправка на GitHub..." -ForegroundColor Yellow
git push origin main
git push origin "v$Version"
Write-Host "Отправлено на GitHub!" -ForegroundColor Green
Write-Host ""

# 7. Готово!
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Релиз v$Version успешно создан!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Что происходит дальше:" -ForegroundColor Cyan
Write-Host "  1. GitHub Actions начнет сборку (займет ~5-10 минут)" -ForegroundColor White
Write-Host "  2. Будет создан Release с Setup.exe и пакетами обновления" -ForegroundColor White
Write-Host "  3. Пользователи получат обновление при следующем запуске приложения" -ForegroundColor White
Write-Host ""
Write-Host "Проверить статус сборки:" -ForegroundColor Cyan
Write-Host "  https://github.com/Fotters05/contracts2512/actions" -ForegroundColor Blue
Write-Host ""
Write-Host "Посмотреть Release:" -ForegroundColor Cyan
Write-Host "  https://github.com/Fotters05/contracts2512/releases" -ForegroundColor Blue
Write-Host ""
