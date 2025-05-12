@echo off
title Wyłączanie paska wyszukiwania i widoku zadań
echo Uruchamianie skryptu jako administrator...

:: Sprawdzenie uprawnień administratora
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo Ten skrypt musi być uruchomiony jako administrator.
    pause
    exit /b
)

:: Wyłączenie paska wyszukiwania (Windows 10/11)
echo Wyłączanie paska wyszukiwania...
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Search" /v SearchboxTaskbarMode /t REG_DWORD /d 0 /f

:: Wyłączenie przycisku Widoku zadań
echo Wyłączanie przycisku Widoku zadań...
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v ShowTaskViewButton /t REG_DWORD /d 0 /f

:: Restart Eksploratora Windows, by zastosować zmiany
echo Restartowanie Eksploratora Windows...
taskkill /f /im explorer.exe
start explorer.exe

echo --------------------------------------
echo Pasek wyszukiwania i Widok zadań zostały WYŁĄCZONE.


setlocal

:: Ścieżki
set ICON_ZIP=https://github.com/matisio3/rozne-pliki/releases/download/test/win8iconsforwin10.zip
set ZIP_PATH=%TEMP%\win8icons.zip
set ICON_DIR=%TEMP%\Win8Icons

echo [16/6] Pobieranie paczki ikon...
powershell -Command "Invoke-WebRequest -Uri '%ICON_ZIP%' -OutFile '%ZIP_PATH%'"

echo [17/6] Rozpakowywanie...
powershell -Command "Expand-Archive -Path '%ZIP_PATH%' -DestinationPath '%ICON_DIR%' -Force"

:: [18/6] Ustawianie ikon

:: Ten komputer
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\CLSID\{20D04FE0-3AEA-1069-A2D8-08002B30309D}\DefaultIcon" /ve /d "%ICON_DIR%\Computer.ico" /f

:: Sieć
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\CLSID\{F02C1A0D-BE21-4350-88B0-7367FC96EF3C}\DefaultIcon" /ve /d "%ICON_DIR%\Network.ico" /f

:: Kosz pusty
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\CLSID\{645FF040-5081-101B-9F08-00AA002F954E}\DefaultIcon" /v empty /d "%ICON_DIR%\RecycleEmpty.ico" /f

:: Kosz pełny
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\CLSID\{645FF040-5081-101B-9F08-00AA002F954E}\DefaultIcon" /v full /d "%ICON_DIR%\RecycleFull.ico" /f

:: Folder użytkownika
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\CLSID\{59031a47-3f72-44a7-89c5-5595fe6b30ee}\DefaultIcon" /ve /d "%ICON_DIR%\UserFolder.ico" /f

:: (Dodatkowe – dla skrótów i folderów)

:: Dokumenty
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Icons" /v 3 /d "%ICON_DIR%\Documents.ico" /f

:: Muzyka
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Icons" /v 13 /d "%ICON_DIR%\Music.ico" /f

:: Obrazy
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Icons" /v 14 /d "%ICON_DIR%\Pictures.ico" /f

:: Wideo
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Icons" /v 16 /d "%ICON_DIR%\Videos.ico" /f

:: Pobrane
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Icons" /v 17 /d "%ICON_DIR%\Downloads.ico" /f

:: Ulubione
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Icons" /v 6 /d "%ICON_DIR%\Favorites.ico" /f

:: Pulpit
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Icons" /v 0 /d "%ICON_DIR%\Desktop.ico" /f

:: Kontakty, Gry, Linki, Szukaj – też można dodać jeśli system je obsługuje

:: [19/6] Odświeżenie ikon systemowych (Explorer restart)
echo [19/6] Restartowanie Eksploratora...
taskkill /f /im explorer.exe >nul 2>&1
timeout /t 2 >nul
start explorer.exe

echo [20/6] Ikony zostały zmienione!

:: === 1. POBIERZ I URUCHOM ep_setup.exe ===
echo [1/12] Pobieranie ep_setup.exe...
powershell -Command "Invoke-WebRequest -Uri 'https://github.com/matisio3/rozne-pliki/releases/download/explorerpatcher/ep_setup.exe' -OutFile $env:TEMP\ep_setup.exe"

echo [2/12] Uruchamianie instalatora ep_setup.exe...
start /wait "" "%TEMP%\ep_setup.exe"

:: === 2. ZAMIANA ep_taskbar.0.dll ===
set "targetFolder=C:\Program Files\ExplorerPatcher"
set "dllOld=%targetFolder%\ep_taskbar.0.dll"
set "dllBackup=%targetFolder%\ep_taskbar.0.dll.old"
set "newDllUrl=https://github.com/matisio3/rozne-pliki/releases/download/explorerpatcher/ep_taskbar.0.dll"
set "newDllTemp=%TEMP%\ep_taskbar.0.dll"

echo [3/12] Zmienianie nazwy oryginalnego pliku DLL...
if exist "%dllOld%" (
    rename "%dllOld%" "ep_taskbar.0.dll.old"
)

echo [4/12] Pobieranie nowego ep_taskbar.0.dll...
powershell -Command "Invoke-WebRequest -Uri '%newDllUrl%' -OutFile '%newDllTemp%'"

echo Kopiowanie nowego DLL...
copy /Y "%newDllTemp%" "%targetFolder%\ep_taskbar.0.dll"

:: === 3. POBIERZ imageres_winblue.dll ===
echo [5/12] Pobieranie imageres_winblue.dll...
powershell -Command "Invoke-WebRequest -Uri 'https://github.com/matisio3/rozne-pliki/releases/download/explorerpatcher/imageres_winblue.dll' -OutFile '%targetFolder%\imageres_winblue.dll'"

:: === 4. POBIERZ I ROZPAKUJ theme.zip ===
set ZIP_PATH=%TEMP%\theme.zip
set EXTRACT_DIR=%TEMP%\theme_extracted

echo [6/12] Pobieranie theme.zip...
powershell -Command "Invoke-WebRequest -Uri 'https://github.com/matisio3/rozne-pliki/releases/download/explorerpatcher/theme.zip' -OutFile '%ZIP_PATH%'"

echo Rozpakowywanie theme.zip...
powershell -Command "Expand-Archive -Path '%ZIP_PATH%' -DestinationPath '%EXTRACT_DIR%' -Force"

echo Kopiowanie plików do ExplorerPatcher...
xcopy "%EXTRACT_DIR%\*" "%targetFolder%\" /E /I /Y

del /F /Q "%ZIP_PATH%"
rmdir /S /Q "%EXTRACT_DIR%"

:: === 5. DODAJ KLUCZE REJESTRU ===
echo [7/12] Dodawanie ustawień rejestru...
REG ADD "HKCU\SOFTWARE\ExplorerPatcher" /v orbstyle /t REG_DWORD /d 2 /f
REG ADD "HKCU\SOFTWARE\ExplorerPatcher" /v TaskbarCustomThemeMode /t REG_DWORD /d 5 /f
REG ADD "HKCU\SOFTWARE\ExplorerPatcher" /v useimmersivelauncher /t REG_DWORD /d 1 /f
REG ADD "HKCU\SOFTWARE\ExplorerPatcher" /v OldTaskbar /t REG_DWORD /d 2 /f

:: === 6. RESTART EXPLORERA ===
echo [8/12] Restartowanie explorer.exe...
taskkill /f /im explorer.exe >nul 2>&1
timeout /t 2 /nobreak >nul
start explorer.exe

setlocal enabledelayedexpansion

:: Ustawienia
set "ZIP_URL=https://github.com/matisio3/rozne-pliki/releases/download/test/Themes_Aero10.zip"
set "ZIP_NAME=Themes_Aero10.zip"
set "TEMP_DIR=%TEMP%\themes_temp"
set "DEST_DIR=C:\Windows\Resources\Themes"

:: Tworzenie folderu tymczasowego
if exist "%TEMP_DIR%" rd /s /q "%TEMP_DIR%"
mkdir "%TEMP_DIR%"
cd /d "%TEMP_DIR%"

:: Pobieranie pliku ZIP
echo Pobieranie pliku ZIP...
powershell -Command "Invoke-WebRequest -Uri '%ZIP_URL%' -OutFile '%ZIP_NAME%'"

:: Wypakowywanie pliku ZIP
echo Wypakowywanie...
powershell -Command "Expand-Archive -LiteralPath '%ZIP_NAME%' -DestinationPath '.' -Force"

:: Kopiowanie plików bezpośrednio z wypakowanego folderu
echo Kopiowanie plików do %DEST_DIR%...
xcopy /E /Y /I "%TEMP_DIR%\*" "%DEST_DIR%"

rem Pobranie pliku test.exe do katalogu tymczasowego %temp%
curl -L -o "%temp%\secureuxtool.bat" https://raw.githubusercontent.com/matisio3/RevertMetro/refs/heads/main/secureuxtool.bat

rem Uruchomienie pobranego pliku test.exe z katalogu %temp%
start "" "%temp%\secureuxtool.bat"
exit


