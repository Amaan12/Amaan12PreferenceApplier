<#
.SYNOPSIS
    Applies Amaan12's personal Windows configurations, explorer tweaks, theme preferences, and shortcuts.
.DESCRIPTION
    Configures:
    - Show Hidden Files & Folders
    - Show Known File Extensions
    - Left-Aligned Taskbar (Windows 11)
    - Hide Task View Button
    - Hide Widgets / Dashboard Button
    - Windows & Apps Dark Mode with Transparency
    - Long Paths Enabled (Filesystem MAX_PATH bypass)
    - Short Date Format ("dd-MMM-yy")
    - Custom Accent Color (#00A898) without title bar coloring
    - Enable Aero Peek
    - Title Bar Window Shake (Aero Shake)
    - Classic Windows 10 Right-Click Context Menu (bypassing Win 11 "Show more options")
#>

Write-Host "Applying Amaan12's Windows Preferences..." -ForegroundColor Cyan

# 1. Explorer & Taskbar Tweaks
$advPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"
if (-not (Test-Path $advPath)) { New-Item -Path $advPath -Force | Out-Null }

Set-ItemProperty -Path $advPath -Name "Hidden" -Type DWord -Value 1
Set-ItemProperty -Path $advPath -Name "HideFileExt" -Type DWord -Value 0
Set-ItemProperty -Path $advPath -Name "TaskbarAl" -Type DWord -Value 0
Set-ItemProperty -Path $advPath -Name "ShowTaskViewButton" -Type DWord -Value 0
Set-ItemProperty -Path $advPath -Name "TaskbarDa" -Type DWord -Value 0
Set-ItemProperty -Path $advPath -Name "DisallowShaking" -Type DWord -Value 0

# 2. Personalization & Dark Mode
$themesPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize"
if (-not (Test-Path $themesPath)) { New-Item -Path $themesPath -Force | Out-Null }

Set-ItemProperty -Path $themesPath -Name "AppsUseLightTheme" -Type DWord -Value 0
Set-ItemProperty -Path $themesPath -Name "SystemUsesLightTheme" -Type DWord -Value 0
Set-ItemProperty -Path $themesPath -Name "EnableTransparency" -Type DWord -Value 1

# 3. Accent Color & Aero Peek
$dwmPath = "HKCU:\Software\Microsoft\Windows\DWM"
if (-not (Test-Path $dwmPath)) { New-Item -Path $dwmPath -Force | Out-Null }

Set-ItemProperty -Path $dwmPath -Name "AccentColor" -Type DWord -Value 4286644328
Set-ItemProperty -Path $dwmPath -Name "ColorPrevalence" -Type DWord -Value 0
Set-ItemProperty -Path $dwmPath -Name "EnableAeroPeek" -Type DWord -Value 1

# 4. Short Date Format (dd-MMM-yy)
$intlPath = "HKCU:\Control Panel\International"
Set-ItemProperty -Path $intlPath -Name "sShortDate" -Type String -Value "dd-MMM-yy"

# 5. Long Paths Enabled (requires admin for HKLM; gracefully skip if unprivileged)
try {
    $fsPath = "HKLM:\SYSTEM\CurrentControlSet\Control\FileSystem"
    Set-ItemProperty -Path $fsPath -Name "LongPathsEnabled" -Type DWord -Value 1 -ErrorAction Stop
} catch {
    Write-Host "Notice: Run PowerShell as Administrator to toggle LongPathsEnabled (MAX_PATH bypass)." -ForegroundColor Yellow
}

# 6. Classic Windows 10 Right-Click Context Menu
$classicMenuKey = "HKCU:\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32"
if (-not (Test-Path $classicMenuKey)) {
    New-Item -Path $classicMenuKey -Force | Out-Null
}
Set-ItemProperty -Path $classicMenuKey -Name "(Default)" -Value ""

# Restart Windows Explorer to apply UI changes immediately
Write-Host "Restarting Windows Explorer to apply changes..." -ForegroundColor Green
Stop-Process -Name explorer -Force -ErrorAction SilentlyContinue
Start-Sleep -Seconds 1
Start-Process explorer.exe

Write-Host "Done! All preferences applied successfully." -ForegroundColor Cyan
