# 🎨 Настройка красивого установщика

## Что нужно сделать:

### 1. Создать Splash Screen изображение

Создай файл `splash.png` в корне проекта со следующими параметрами:
- **Размер**: 600x400 пикселей (рекомендуется)
- **Формат**: PNG с прозрачностью
- **Содержание**: 
  - Логотип приложения
  - Название "Contract2512"
  - Текст "Установка..." или "Идет установка"
  - Можно добавить прогресс-бар или анимацию

### 2. Пример содержимого splash.png:

```
┌─────────────────────────────────────┐
│                                     │
│         [ЛОГОТИП/ИКОНКА]           │
│                                     │
│          Contract2512               │
│                                     │
│      Установка приложения...        │
│                                     │
│         [═══════════]               │
│                                     │
└─────────────────────────────────────┘
```

### 3. Добавить в .csproj

Файл уже настроен для включения иконки. Добавим splash:

```xml
<ItemGroup>
  <Content Include="progaico.ico" />
  <Content Include="splash.png">
    <CopyToOutputDirectory>PreserveNewest</CopyToOutputDirectory>
  </Content>
</ItemGroup>
```

### 4. Что получится:

После этих изменений Setup.exe будет:
- ✅ Показывать твой splash screen во время установки
- ✅ Использовать иконку приложения
- ✅ Выглядеть профессионально

## Альтернатива: WiX Toolset (более сложно, но максимально кастомизируемо)

Если нужен полноценный установщик с:
- Выбором папки установки
- Лицензионным соглашением
- Выбором компонентов
- Прогресс-баром
- Кастомными страницами

То нужно использовать WiX Toolset. Это займет больше времени, но даст полный контроль.

## Быстрый способ создать splash.png:

### Вариант 1: Онлайн редактор
1. Открой https://www.canva.com или https://www.photopea.com
2. Создай изображение 600x400
3. Добавь:
   - Фон (градиент или цвет)
   - Логотип в центре
   - Текст "Contract2512"
   - Текст "Установка приложения..."
4. Экспортируй как PNG

### Вариант 2: PowerShell скрипт (простой splash)

Создай файл `create-splash.ps1`:

```powershell
Add-Type -AssemblyName System.Drawing

$width = 600
$height = 400
$bitmap = New-Object System.Drawing.Bitmap($width, $height)
$graphics = [System.Drawing.Graphics]::FromImage($bitmap)

# Фон
$brush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(45, 45, 48))
$graphics.FillRectangle($brush, 0, 0, $width, $height)

# Текст
$font = New-Object System.Drawing.Font("Segoe UI", 32, [System.Drawing.FontStyle]::Bold)
$fontSmall = New-Object System.Drawing.Font("Segoe UI", 16)
$textBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::White)

$text1 = "Contract2512"
$text2 = "Установка приложения..."

$size1 = $graphics.MeasureString($text1, $font)
$size2 = $graphics.MeasureString($text2, $fontSmall)

$x1 = ($width - $size1.Width) / 2
$y1 = ($height - $size1.Height) / 2 - 40

$x2 = ($width - $size2.Width) / 2
$y2 = ($height - $size2.Height) / 2 + 40

$graphics.DrawString($text1, $font, $textBrush, $x1, $y1)
$graphics.DrawString($text2, $fontSmall, $textBrush, $x2, $y2)

# Сохранить
$bitmap.Save("splash.png", [System.Drawing.Imaging.ImageFormat]::Png)

$graphics.Dispose()
$bitmap.Dispose()

Write-Host "Splash screen создан: splash.png" -ForegroundColor Green
```

Запусти: `powershell -ExecutionPolicy Bypass -File create-splash.ps1`

## После создания splash.png:

1. Положи файл в корень проекта (рядом с Contract2512.csproj)
2. Добавь в git:
```bash
git add splash.png
git commit -m "Add installer splash screen"
git push
```

3. Создай новый тег для тестирования:
```bash
git tag v1.0.2
git push origin v1.0.2
```

4. GitHub Actions создаст новый Setup.exe с твоим splash screen!

## Что дальше?

Скажи, какой вариант тебе больше нравится:
1. **Простой splash screen** (быстро, достаточно для большинства случаев)
2. **WiX Toolset** (долго, но максимальная кастомизация)

Или можешь просто создать splash.png и я помогу его интегрировать!
