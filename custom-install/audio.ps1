$target = "C:\Windows\Media"
$zipUrl = "https://github.com/matisio3/RevertMetro/raw/refs/heads/main/DLLFiles/Media.zip"
$tempDir = Join-Path $env:TEMP "RevertMetroTemp"
$zipPath = Join-Path $tempDir "Media.zip"
$mediaExtractedPath = Join-Path $tempDir "Media"

if (Test-Path $tempDir) { Remove-Item $tempDir -Recurse -Force }
New-Item -ItemType Directory -Path $tempDir | Out-Null

Invoke-WebRequest -Uri $zipUrl -OutFile $zipPath
Expand-Archive -Path $zipPath -DestinationPath $tempDir -Force

takeown /f $target /r /d Y | Out-Null
icacls $target /grant administrators:F /t | Out-Null

Get-ChildItem -Path $target -Recurse -Force | Remove-Item -Force -Recurse -ErrorAction SilentlyContinue
Copy-Item -Path "$mediaExtractedPath\*" -Destination $target -Recurse -Force

Remove-Item $tempDir -Recurse -Force
