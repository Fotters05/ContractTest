Add-Type -AssemblyName System.Drawing

$width = 600
$height = 400
$bitmap = New-Object System.Drawing.Bitmap($width, $height)
$graphics = [System.Drawing.Graphics]::FromImage($bitmap)

# Включаем сглаживание
$graphics.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
$graphics.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::AntiAlias

# Градиентный фон (синий)
$rect = New-Object System.Drawing.Rectangle(0, 0, $width, $height)
$brush = New-Object System.Drawing.Drawing2D.LinearGradientBrush(
    $rect,
    [System.Drawing.Color]::FromArgb(30, 60, 114),
    [System.Drawing.Color]::FromArgb(42, 82, 152),
    [System.Drawing.Drawing2D.LinearGradientMode]::Vertical
)
$graphics.FillRectangle($brush, $rect)

# Заголовок
$font = New-Object System.Drawing.Font("Segoe UI", 36, [System.Drawing.FontStyle]::Bold)
$textBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::White)

$text1 = "Contract2512"
$size1 = $graphics.MeasureString($text1, $font)
$x1 = ($width - $size1.Width) / 2
$y1 = 120

$graphics.DrawString($text1, $font, $textBrush, $x1, $y1)

# Подзаголовок
$fontSmall = New-Object System.Drawing.Font("Segoe UI", 18)
$text2 = "Installing application..."
$size2 = $graphics.MeasureString($text2, $fontSmall)
$x2 = ($width - $size2.Width) / 2
$y2 = 220

$graphics.DrawString($text2, $fontSmall, $textBrush, $x2, $y2)

# Прогресс-бар (декоративный)
$barWidth = 300
$barHeight = 6
$barX = ($width - $barWidth) / 2
$barY = 280

# Фон прогресс-бара
$barBackBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(100, 255, 255, 255))
$graphics.FillRectangle($barBackBrush, $barX, $barY, $barWidth, $barHeight)

# Заполненная часть прогресс-бара
$barFillBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 255, 255))
$graphics.FillRectangle($barFillBrush, $barX, $barY, $barWidth * 0.7, $barHeight)

# Версия внизу
$fontVersion = New-Object System.Drawing.Font("Segoe UI", 10)
$versionBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(180, 255, 255, 255))
$text3 = "Version 1.1.8"
$size3 = $graphics.MeasureString($text3, $fontVersion)
$x3 = ($width - $size3.Width) / 2
$y3 = $height - 40

$graphics.DrawString($text3, $fontVersion, $versionBrush, $x3, $y3)

# Сохранить
$bitmap.Save("splash.png", [System.Drawing.Imaging.ImageFormat]::Png)

$graphics.Dispose()
$bitmap.Dispose()
$brush.Dispose()
$textBrush.Dispose()
$barBackBrush.Dispose()
$barFillBrush.Dispose()
$versionBrush.Dispose()

Write-Host "✅ Splash screen создан: splash.png" -ForegroundColor Green
Write-Host "📏 Размер: 600x400 пикселей" -ForegroundColor Cyan
Write-Host "📁 Файл готов к использованию!" -ForegroundColor Cyan
