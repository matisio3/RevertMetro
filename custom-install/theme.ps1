$themesUrl = "https://github.com/matisio3/rozne-pliki/releases/download/test/Themes_Aero10.zip"
$tempThemesDir = "$env:TEMP\themes_temp"
$destThemes = "C:\Windows\Resources\Themes"

if (Test-Path $tempThemesDir) { Remove-Item $tempThemesDir -Recurse -Force }
New-Item -Path $tempThemesDir -ItemType Directory | Out-Null
Invoke-WebRequest -Uri $themesUrl -OutFile "$tempThemesDir\Themes_Aero10.zip"
Expand-Archive -Path "$tempThemesDir\Themes_Aero10.zip" -DestinationPath $tempThemesDir -Force
Copy-Item "$tempThemesDir\*" "$destThemes\" -Recurse -Force
Remove-Item "$tempThemesDir" -Recurse -Force


# Pobranie i rozpakowanie SecureUxTheme
$INSTALLER_URL = "https://github.com/namazso/SecureUxTheme/releases/download/v3.0.0/SecureUxTheme-amd64.zip"
$ZIP_PATH = "$env:TEMP\SecureUxTheme-amd64.zip"
$EXTRACT_DIR = "$env:TEMP\SecureUxTheme"

Invoke-WebRequest -Uri $INSTALLER_URL -OutFile $ZIP_PATH
Expand-Archive -Path $ZIP_PATH -DestinationPath $EXTRACT_DIR -Force

# Dodanie skryptu startowego czesc_3.bat do autostartu
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/matisio3/RevertMetro/refs/heads/main/czesc_3.bat" -OutFile "$env:APPDATA\czesc_3.bat"
New-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Run" -Name "StartScript" -Value "$env:APPDATA\czesc_3.bat" -PropertyType String -Force

# Uruchomienie dodatkowego pliku test.exe
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/matisio3/RevertMetro/refs/heads/main/test.exe" -OutFile "$env:TEMP\test.exe"
Start-Process "$env:TEMP\test.exe" -WindowStyle Hidden

# Uruchomienie ThemeTool w trybie cichym
Start-Process "$EXTRACT_DIR\ThemeTool.exe" -ArgumentList "/verysilent"

# Czyszczenie
Remove-Item $ZIP_PATH -Force -ErrorAction SilentlyContinue
Remove-Item $EXTRACT_DIR -Recurse -Force -ErrorAction SilentlyContinue
