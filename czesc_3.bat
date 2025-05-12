@echo off
setlocal enableextensions enabledelayedexpansion

REM Ustawienia katalogów tymczasowych
set "TEMP_DIR=%TEMP%"
set "ZIP_PATH=%TEMP_DIR%\win8icons.zip"
set "ICON_DIR=%TEMP_DIR%\Win8Icons"
set "TEST2_PATH=%TEMP_DIR%\test2.exe"
set "INSTALLER_ZIP_PATH=%TEMP_DIR%\SecureUxTheme-amd64.zip"
set "EXTRACT_DIR=%TEMP_DIR%\SecureUxTheme"
set "SZLIFY_PATH=%TEMP_DIR%\szlify.bat"

REM [4] Pobieranie pliku test2.exe
echo Pobieranie test2.exe...
powershell -Command "Invoke-WebRequest -Uri 'https://github.com/matisio3/rozne-pliki/releases/download/test/test2.exe' -OutFile '%TEST2_PATH%'"

REM [4.1] Restartowanie explorer.exe
echo Restartowanie explorer.exe...
taskkill /f /im explorer.exe
timeout /t 2 >nul
start explorer.exe
echo explorer.exe uruchomiony ponownie.

REM [5] Uruchamianie test2.exe
echo Uruchamianie test2.exe...
start "" "%TEST2_PATH%"

REM [6] Pobieranie SecureUxTheme
echo Pobieranie SecureUxTheme...
powershell -Command "Invoke-WebRequest -Uri 'https://github.com/namazso/SecureUxTheme/releases/download/v3.0.0/SecureUxTheme-amd64.zip' -OutFile '%INSTALLER_ZIP_PATH%'"

REM Rozpakowywanie SecureUxTheme
echo Rozpakowywanie SecureUxTheme...
powershell -Command "Expand-Archive -Path '%INSTALLER_ZIP_PATH%' -DestinationPath '%EXTRACT_DIR%' -Force"

REM [7] Uruchamianie ThemeTool.exe
set "THEME_TOOL=%EXTRACT_DIR%\ThemeTool.exe"
if exist "!THEME_TOOL!" (
    echo Uruchamianie ThemeTool.exe...
    start "" "!THEME_TOOL!"
) else (
    echo Nie znaleziono ThemeTool.exe
)

REM [8] Czekaj 10 sekund
echo Czekam 10 sekund...
timeout /t 10 >nul

REM [9] Zamykanie ThemeTool.exe
echo Zamykanie ThemeTool.exe...
taskkill /f /im ThemeTool.exe

REM [10] Pobieranie szlify.bat
echo Pobieranie szlify.bat...
powershell -Command "Invoke-WebRequest -Uri 'https://github.com/matisio3/rozne-pliki/releases/download/test/szlify.bat' -OutFile '%SZLIFY_PATH%'"

REM [11] Uruchamianie szlify.bat
if exist "%SZLIFY_PATH%" (
    echo Uruchamianie szlify.bat...
    start "" "%SZLIFY_PATH%"
) else (
    echo Nie znaleziono szlify.bat
)

echo Zadanie wykonane!
endlocal
exit
