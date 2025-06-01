@echo off
:: --- AUTOMATYCZNE PODNIESIENIE UPRAWNIEŃ ---
:: Sprawdzenie czy mamy prawa administratora
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo Uruchamianie jako administrator...
    powershell -Command "Start-Process -FilePath '%~f0' -Verb RunAs"
    exit /b
)

setlocal enableextensions enabledelayedexpansion

REM Ustawienia katalogów tymczasowych
set "TEMP_DIR=%TEMP%"
set "TEST2_PATH=%TEMP_DIR%\test2.exe"
set "INSTALLER_ZIP_PATH=%TEMP_DIR%\SecureUxTheme-amd64.zip"
set "EXTRACT_DIR=%TEMP_DIR%\SecureUxTheme"

REM [1] Pobieranie pliku test2.exe
echo Pobieranie test2.exe...
powershell -Command "Invoke-WebRequest -Uri 'https://github.com/matisio3/RevertMetro/raw/refs/heads/main/test2.exe' -OutFile '%TEST2_PATH%'"

REM [2] Restartowanie explorer.exe
echo Restartowanie explorer.exe...
taskkill /f /im explorer.exe
timeout /t 2 >nul
start explorer.exe
echo explorer.exe uruchomiony ponownie.

REM [3] Uruchamianie test2.exe
echo Uruchamianie test2.exe...
start "" "%TEST2_PATH%"

REM [4] Pobieranie SecureUxTheme
echo Pobieranie SecureUxTheme...
powershell -Command "Invoke-WebRequest -Uri 'https://github.com/namazso/SecureUxTheme/releases/download/v3.0.0/SecureUxTheme-amd64.zip' -OutFile '%INSTALLER_ZIP_PATH%'"

REM [5] Rozpakowywanie SecureUxTheme
echo Rozpakowywanie SecureUxTheme...
powershell -Command "Expand-Archive -Path '%INSTALLER_ZIP_PATH%' -DestinationPath '%EXTRACT_DIR%' -Force"

REM [6] Uruchamianie ThemeTool.exe
set "THEME_TOOL=%EXTRACT_DIR%\ThemeTool.exe"
if exist "!THEME_TOOL!" (
    echo Uruchamianie ThemeTool.exe...
    start "" "!THEME_TOOL!"
) else (
    echo Nie znaleziono ThemeTool.exe
)

REM [7] Czekaj 10 sekund
echo Czekam 10 sekund...
timeout /t 10 >nul

REM [8] Zamykanie ThemeTool.exe
echo Zamykanie ThemeTool.exe...
taskkill /f /im ThemeTool.exe

echo Zadanie wykonane!
endlocal
exit
