# 🚀 Быстрый старт: Красивый установщик

## ✅ Что уже сделано:

1. ✅ Workflow настроен для создания установщика с splash screen
2. ✅ Создан файл `splash.png` (600x400, синий градиент)
3. ✅ Настроен `.csproj` для включения splash screen
4. ✅ Добавлены параметры `--appIcon` и `--splashImage` в workflow

## 📦 Что получится:

Теперь `Setup.exe` будет:
- Показывать красивый splash screen во время установки
- Использовать иконку приложения
- Выглядеть профессионально

## 🎯 Следующие шаги:

### 1. Закоммить изменения:

```bash
git add .
git commit -m "Add installer splash screen"
git push origin main
```

### 2. Создать новый релиз:

```bash
# Обнови версию в Contract2512.csproj на 1.0.2
git add Contract2512.csproj
git commit -m "Bump version to 1.0.2"
git tag v1.0.2
git push origin main --tags
```

### 3. Дождаться сборки:

- Перейди в GitHub Actions
- Дождись завершения workflow
- Скачай новый Setup.exe из Releases

### 4. Протестировать:

- Запусти Setup.exe
- Увидишь splash screen во время установки
- Приложение установится с иконкой

## 🎨 Кастомизация splash screen:

Если хочешь изменить дизайн:

1. Отредактируй `create-splash.ps1`:
   - Измени цвета градиента
   - Измени текст
   - Измени шрифты
   - Добавь логотип

2. Запусти скрипт заново:
```bash
powershell -ExecutionPolicy Bypass -File create-splash.ps1
```

3. Закоммить новый `splash.png`

## 🖼️ Добавить свой логотип:

Если у тебя есть логотип (logo.png):

1. Положи его в корень проекта
2. Отредактируй `create-splash.ps1`, добавь после создания фона:

```powershell
# Загрузить логотип
if (Test-Path "logo.png") {
    $logo = [System.Drawing.Image]::FromFile("logo.png")
    $logoWidth = 100
    $logoHeight = 100
    $logoX = ($width - $logoWidth) / 2
    $logoY = 40
    $graphics.DrawImage($logo, $logoX, $logoY, $logoWidth, $logoHeight)
    $logo.Dispose()
}
```

3. Запусти скрипт заново

## 📝 Текущие параметры splash screen:

- **Размер**: 600x400 пикселей
- **Фон**: Синий градиент (RGB: 30,60,114 → 42,82,152)
- **Заголовок**: "Contract2512" (Segoe UI, 36pt, Bold)
- **Подзаголовок**: "Установка приложения..." (Segoe UI, 18pt)
- **Прогресс-бар**: Декоративный (70% заполнен)
- **Версия**: Внизу по центру (Segoe UI, 10pt)

## 🔧 Альтернатива: Использовать свой PNG

Если хочешь использовать готовый дизайн:

1. Создай `splash.png` в любом редакторе (Photoshop, Figma, Canva)
2. Размер: 600x400 пикселей
3. Положи в корень проекта
4. Готово!

## ❓ Проблемы?

Если splash screen не отображается:
1. Проверь, что `splash.png` есть в корне проекта
2. Проверь, что файл добавлен в git
3. Проверь логи GitHub Actions
4. Убедись, что версия Clowd.Squirrel поддерживает `--splashImage`

## 🎉 Готово!

Теперь у тебя профессиональный установщик с красивым splash screen!
