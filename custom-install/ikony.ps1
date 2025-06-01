takeown.exe /f "C:\Windows\SystemResources\"
icacls.exe "C:\Windows\SystemResources\shell32.dll.mun" /grant "*S-1-5-32-544:F" /t /c /l

# Zamiana plików DLL na starsze wersje
Rename-Item -Path "C:\Windows\System32\imageres.dll" -NewName "imageres.dll.old"
Rename-Item -Path "C:\Windows\SystemResources\shell32.dll.mun" -NewName "shell32.dll.mun.old"

$temp = $env:TEMP
Invoke-WebRequest -Uri "https://github.com/matisio3/RevertMetro/releases/download/Other/imageres.dll" -OutFile "$temp\imageres.dll"
Invoke-WebRequest -Uri "https://github.com/matisio3/RevertMetro/raw/refs/heads/main/DLLFiles/shell32.dll.mun" -OutFile "$temp\shell32.dll.mun"

Move-Item -Path "$temp\imageres.dll" -Destination "C:\Windows\System32\" -Force
Move-Item -Path "$temp\shell32.dll.mun" -Destination "C:\Windows\SystemResources\" -Force

# Czyszczenie cache ikon
Stop-Process -Name explorer -Force
Remove-Item "$env:LOCALAPPDATA\IconCache.db" -Force -ErrorAction SilentlyContinue
Remove-Item "$env:LOCALAPPDATA\Microsoft\Windows\Explorer\iconcache*" -Force -ErrorAction SilentlyContinue
Start-Process explorer.exe -Wait