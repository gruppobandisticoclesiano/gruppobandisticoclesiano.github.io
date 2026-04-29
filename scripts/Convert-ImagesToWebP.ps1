[CmdletBinding(SupportsShouldProcess = $true)]
param(
    [string]$SourceDir,
    [int]$Quality = 82,
    [switch]$Force,
    [switch]$LosslessPng
)

$ErrorActionPreference = "Stop"

if ([string]::IsNullOrWhiteSpace($SourceDir)) {
    $SourceDir = Join-Path $PSScriptRoot "..\images"
}

if ($Quality -lt 1 -or $Quality -gt 100) {
    throw "Quality must be between 1 and 100."
}

$resolvedSource = Resolve-Path -LiteralPath $SourceDir -ErrorAction Stop
$sourcePath = $resolvedSource.ProviderPath

$cwebp = Get-Command cwebp -ErrorAction SilentlyContinue
$ffmpeg = Get-Command ffmpeg -ErrorAction SilentlyContinue

if (-not $cwebp -and -not $ffmpeg) {
    throw "No WebP encoder found. Install cwebp, ImageMagick, or ffmpeg and try again."
}

$encoder = if ($cwebp) { "cwebp" } else { "ffmpeg" }
$supportedExtensions = @(".jpg", ".jpeg", ".png")

$images = Get-ChildItem -LiteralPath $sourcePath -Recurse -File |
    Where-Object { $supportedExtensions -contains $_.Extension.ToLowerInvariant() }

if (-not $images) {
    Write-Host "No JPG, JPEG, or PNG images found in $sourcePath."
    return
}

$converted = 0
$skipped = 0
$failed = 0

foreach ($image in $images) {
    $outputPath = [System.IO.Path]::ChangeExtension($image.FullName, ".webp")
    $outputFile = Get-Item -LiteralPath $outputPath -ErrorAction SilentlyContinue

    if (-not $Force -and $outputFile -and $outputFile.LastWriteTimeUtc -ge $image.LastWriteTimeUtc) {
        Write-Host "Skip: $($image.FullName)"
        $skipped++
        continue
    }

    $action = "Convert to WebP"
    if (-not $PSCmdlet.ShouldProcess($image.FullName, $action)) {
        continue
    }

    try {
        if ($encoder -eq "cwebp") {
            $args = @()

            if ($LosslessPng -and $image.Extension.ToLowerInvariant() -eq ".png") {
                $args += "-lossless"
            }
            else {
                $args += @("-q", $Quality)
            }

            $args += @($image.FullName, "-o", $outputPath)
            & $cwebp.Source @args | Out-Null
        }
        else {
            $overwriteFlag = if ($Force) { "-y" } else { "-n" }
            $args = @(
                "-hide_banner",
                "-loglevel", "error",
                $overwriteFlag,
                "-i", $image.FullName,
                "-c:v", "libwebp"
            )

            if ($LosslessPng -and $image.Extension.ToLowerInvariant() -eq ".png") {
                $args += @("-lossless", "1")
            }
            else {
                $args += @("-quality", $Quality)
            }

            $args += $outputPath
            & $ffmpeg.Source @args
        }

        if ($LASTEXITCODE -ne 0) {
            throw "$encoder exited with code $LASTEXITCODE."
        }

        $originalSize = $image.Length
        $webpSize = (Get-Item -LiteralPath $outputPath).Length
        $savedPercent = if ($originalSize -gt 0) {
            [math]::Round((1 - ($webpSize / $originalSize)) * 100, 1)
        }
        else {
            0
        }

        Write-Host "OK: $($image.FullName) -> $outputPath ($savedPercent% saved)"
        $converted++
    }
    catch {
        Write-Warning "Failed: $($image.FullName) - $($_.Exception.Message)"
        $failed++
    }
}

Write-Host ""
Write-Host "WebP conversion complete."
Write-Host "Encoder: $encoder"
Write-Host "Converted: $converted"
Write-Host "Skipped: $skipped"
Write-Host "Failed: $failed"
