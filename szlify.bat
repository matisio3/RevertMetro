@echo off
reg add "HKCU\Software\Policies\Microsoft\Windows\Explorer" /v DisableNotificationCenter /t REG_DWORD /d 1 /f
reg delete HKCU\Software\Microsoft\Windows\CurrentVersion\Run /v StartScript /f
taskkill /f /im explorer.exe
start explorer.exe
mshta.exe "javascript:alert('Instalacja zostala zakonczona');close();"
