param(
  [string]$OutputPath = (Join-Path $PSScriptRoot '..\assets\twitter-card.png')
)

Add-Type -AssemblyName System.Drawing

$width = 1200
$height = 630
$bitmap = New-Object System.Drawing.Bitmap($width, $height)
$graphics = [System.Drawing.Graphics]::FromImage($bitmap)
$graphics.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
$graphics.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::AntiAliasGridFit
$graphics.Clear([System.Drawing.Color]::FromArgb(17, 19, 21))

function New-Font([string]$family, [float]$size, [System.Drawing.FontStyle]$style = [System.Drawing.FontStyle]::Regular) {
  New-Object System.Drawing.Font($family, $size, $style, [System.Drawing.GraphicsUnit]::Pixel)
}

function Decode-Utf8([string]$value) {
  [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($value))
}

function Draw-Text([string]$text, [System.Drawing.Font]$font, [System.Drawing.Brush]$brush, [float]$x, [float]$y) {
  $graphics.DrawString($text, $font, $brush, $x, $y)
}

function Draw-CenteredText([string]$text, [System.Drawing.Font]$font, [System.Drawing.Brush]$brush, [float]$centerX, [float]$y) {
  $size = $graphics.MeasureString($text, $font)
  $graphics.DrawString($text, $font, $brush, $centerX - ($size.Width / 2), $y)
}

function Draw-RoundedOutline([float]$x, [float]$y, [float]$w, [float]$h, [float]$radius, [System.Drawing.Pen]$pen) {
  $path = New-Object System.Drawing.Drawing2D.GraphicsPath
  $diameter = $radius * 2
  $path.AddArc($x, $y, $diameter, $diameter, 180, 90)
  $path.AddArc($x + $w - $diameter, $y, $diameter, $diameter, 270, 90)
  $path.AddArc($x + $w - $diameter, $y + $h - $diameter, $diameter, $diameter, 0, 90)
  $path.AddArc($x, $y + $h - $diameter, $diameter, $diameter, 90, 90)
  $path.CloseFigure()
  $graphics.DrawPath($pen, $path)
  $path.Dispose()
}

function Draw-RoundedFill([System.Drawing.Brush]$brush, [float]$x, [float]$y, [float]$w, [float]$h, [float]$radius) {
  $path = New-Object System.Drawing.Drawing2D.GraphicsPath
  $diameter = $radius * 2
  $path.AddArc($x, $y, $diameter, $diameter, 180, 90)
  $path.AddArc($x + $w - $diameter, $y, $diameter, $diameter, 270, 90)
  $path.AddArc($x + $w - $diameter, $y + $h - $diameter, $diameter, $diameter, 0, 90)
  $path.AddArc($x, $y + $h - $diameter, $diameter, $diameter, 90, 90)
  $path.CloseFigure()
  $graphics.FillPath($brush, $path)
  $path.Dispose()
}

$white = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(244, 244, 245))
$muted = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(161, 161, 170))
$blue = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(168, 195, 255))
$panel = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(24, 27, 31))
$border = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(52, 55, 61), 1)
$thinBorder = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(52, 55, 61), 1)
$brand = Decode-Utf8 '44K/44Kk5paH5a2X6LaF6YCf57+S'
$questionLabel = Decode-Utf8 '44GT44Gu5a2Q6Z+z44KS6Kqt44KB'
$streakLabel = Decode-Utf8 '6YCj57aaIDAvMTA='
$consonantLabel = Decode-Utf8 '5a2Q6Z+z'
$correctLabel = Decode-Utf8 '5q2j562UIDAvMA=='

Draw-Text $brand (New-Font 'Yu Gothic UI' 24 ([System.Drawing.FontStyle]::Bold)) $white 50 17
Draw-Text 'THAI READING DRILL' (New-Font 'Segoe UI' 16) $muted 875 21

Draw-RoundedFill $panel 40 70 1120 520 22
Draw-RoundedOutline 40 70 1120 520 22 $border
Draw-Text 'STAGE 1B' (New-Font 'Segoe UI' 17) $blue 70 91
Draw-Text $questionLabel (New-Font 'Yu Gothic UI' 26 ([System.Drawing.FontStyle]::Bold)) $white 70 119
Draw-Text $streakLabel (New-Font 'Yu Gothic UI' 16) $white 800 96
Draw-RoundedOutline 900 91 64 34 17 $thinBorder
Draw-CenteredText $consonantLabel (New-Font 'Yu Gothic UI' 13) $white 932 99
Draw-Text $correctLabel (New-Font 'Yu Gothic UI' 16) $white 986 96
Draw-RoundedOutline 1060 91 74 34 17 $thinBorder
Draw-CenteredText 'SCORE 0' (New-Font 'Segoe UI' 15) $white 1097 98

Draw-CenteredText ([char]0x0e01) (New-Font 'Tahoma' 170 ([System.Drawing.FontStyle]::Bold)) $white 600 170

$answerFont = New-Font 'Consolas' 25
Draw-RoundedOutline 70 365 515 74 13 $thinBorder
Draw-CenteredText 'ph' $answerFont $white 327.5 386
Draw-RoundedOutline 615 365 515 74 13 $thinBorder
Draw-CenteredText 'k' $answerFont $white 872.5 386
Draw-RoundedOutline 70 455 515 74 13 $thinBorder
Draw-CenteredText 'kh' $answerFont $white 327.5 476
Draw-RoundedOutline 615 455 515 74 13 $thinBorder
Draw-CenteredText 'w' $answerFont $white 872.5 476

$graphics.DrawLine($thinBorder, 70, 557, 1130, 557)

$targetDir = Split-Path -Parent $OutputPath
if (-not (Test-Path -LiteralPath $targetDir)) {
  New-Item -ItemType Directory -Path $targetDir -Force | Out-Null
}
$bitmap.Save($OutputPath, [System.Drawing.Imaging.ImageFormat]::Png)

foreach ($resource in @($answerFont, $white, $muted, $blue, $panel, $border, $thinBorder, $graphics, $bitmap)) {
  $resource.Dispose()
}
