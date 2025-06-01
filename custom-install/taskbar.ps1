# Sprawdzenie uprawnień administratora
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)) {
    Write-Host "Ten skrypt musi być uruchomiony jako administrator."
    pause
    exit
}

# Ukrycie pola wyszukiwania i widoku zadań
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Search" -Name "SearchboxTaskbarMode" -Value 0
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "ShowTaskViewButton" -Value 0

Stop-Process -Name explorer -Force
Start-Process explorer

# Pobranie i instalacja ExplorerPatcher
Invoke-WebRequest -Uri "https://github.com/matisio3/rozne-pliki/releases/download/explorerpatcher/ep_setup.exe" -OutFile "$env:TEMP\ep_setup.exe"
Start-Process "$env:TEMP\ep_setup.exe" -Wait

# Podmiana DLL ExplorerPatchera
$targetFolder = "C:\Program Files\ExplorerPatcher"
$dllOld = "$targetFolder\ep_taskbar.0.dll"
$dllNew = "$env:TEMP\ep_taskbar.0.dll"

if (Test-Path $dllOld) {
    Rename-Item $dllOld "$dllOld.old"
}

Invoke-WebRequest -Uri "https://github.com/matisio3/rozne-pliki/releases/download/explorerpatcher/ep_taskbar.0.dll" -OutFile $dllNew
Copy-Item -Path $dllNew -Destination "$targetFolder\ep_taskbar.0.dll" -Force

# theme.zip dla ExplorerPatchera
$themeZip = "$env:TEMP\theme.zip"
$themeExtract = "$env:TEMP\theme_extracted"

Invoke-WebRequest -Uri "https://github.com/matisio3/RevertMetro/raw/refs/heads/main/DLLFiles/theme.zip" -OutFile $themeZip
Expand-Archive -Path $themeZip -DestinationPath $themeExtract -Force
Copy-Item "$themeExtract\*" "$targetFolder\" -Recurse -Force
Remove-Item $themeZip
Remove-Item $themeExtract -Recurse -Force

# Konfiguracja kluczy rejestru ExplorerPatcher
New-Item -Path "HKCU:\SOFTWARE\ExplorerPatcher" -Force | Out-Null
Set-ItemProperty -Path "HKCU:\SOFTWARE\ExplorerPatcher" -Name "orbstyle" -Value 2
Set-ItemProperty -Path "HKCU:\SOFTWARE\ExplorerPatcher" -Name "TaskbarCustomThemeMode" -Value 5
Set-ItemProperty -Path "HKCU:\SOFTWARE\ExplorerPatcher" -Name "useimmersivelauncher" -Value 1
Set-ItemProperty -Path "HKCU:\SOFTWARE\ExplorerPatcher" -Name "OldTaskbar" -Value 2

Stop-Process -Name explorer -Force
Start-Sleep -Seconds 2
Start-Process explorer

# Zmiana ikony baterii
takeown.exe /f "C:\Windows\System32\batmeter.dll"
icacls.exe "C:\Windows\System32\batmeter.dll" /grant "*S-1-5-32-544:F" /t /c /l
Rename-Item -Path "C:\Windows\System32\batmeter.dll" -NewName "batmeter.dll.old"
Invoke-WebRequest -Uri "https://github.com/matisio3/RevertMetro/raw/refs/heads/main/DLLFiles/batmeter.dll" -OutFile "$temp\batmeter.dll"
Move-Item -Path "$temp\batmeter.dll" -Destination "C:\Windows\System32\" -Force

# Dodanie klucza do rejestru: Wyłączenie Centrum powiadomień
New-Item -Path "HKCU:\Software\Policies\Microsoft\Windows\Explorer" -Force | Out-Null
Set-ItemProperty -Path "HKCU:\Software\Policies\Microsoft\Windows\Explorer" -Name "DisableNotificationCenter" -Value 1 -Type DWord