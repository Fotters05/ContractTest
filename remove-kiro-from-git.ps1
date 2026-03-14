# Скрипт для удаления папки .kiro из git истории

Write-Host "🗑️  Удаление папки .kiro из git..." -ForegroundColor Yellow

# Удаляем папку из индекса git (но оставляем на диске)
git rm -r --cached .kiro

# Коммитим изменения
git add .gitignore
git commit -m "Remove .kiro folder from git and add to .gitignore"

Write-Host "✅ Папка .kiro удалена из git!" -ForegroundColor Green
Write-Host ""
Write-Host "📤 Теперь запуши изменения:" -ForegroundColor Cyan
Write-Host "   git push origin main" -ForegroundColor White
