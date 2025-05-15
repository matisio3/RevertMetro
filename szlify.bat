@echo off
reg add "HKCU\Software\Policies\Microsoft\Windows\Explorer" /v DisableNotificationCenter /t REG_DWORD /d 1 /f
reg delete HKCU\Software\Microsoft\Windows\CurrentVersion\Run /v StartScript /f
del "C:\Users\Matisio\AppData\Roaming\czesc_3.bat" /s /q
taskkill /f /im explorer.exe
start explorer.exe
setlocal

:: Ścieżka do pobrania pliku
set "URL=https://github.com/matisio3/RevertMetro/raw/refs/heads/main/zainstalowano.ps1"
set "DEST=zainstalowano.ps1"

:: Pobieranie pliku
powershell -Command "Invoke-WebRequest -Uri '%URL%' -OutFile '%DEST%'"

:: Uruchamianie skryptu
powershell -NoProfile -ExecutionPolicy Bypass -File "%DEST%"

endlocal
