# =====================================================================
# Amaan12 Unity Personal Preferences & Shortcuts Setup Script
# =====================================================================

$ErrorActionPreference = "Stop"

Write-Host "`n[Amaan12] Applying Unity Preferences & Shortcuts..." -ForegroundColor Cyan

# 1. Ensure target AppData directories exist
$appData = [Environment]::GetFolderPath([Environment+SpecialFolder]::ApplicationData)
$shortcutDir = Join-Path $appData "Unity\Editor-5.x\Preferences\shortcuts\default"
$layoutRootDir = Join-Path $appData "Unity\Editor-5.x\Preferences\Layouts"
$layoutDefaultDir = Join-Path $layoutRootDir "default"

if (-not (Test-Path $shortcutDir)) { [System.IO.Directory]::CreateDirectory($shortcutDir) | Out-Null }
if (-not (Test-Path $layoutRootDir)) { [System.IO.Directory]::CreateDirectory($layoutRootDir) | Out-Null }
if (-not (Test-Path $layoutDefaultDir)) { [System.IO.Directory]::CreateDirectory($layoutDefaultDir) | Out-Null }

# 2. Deploy Shortcut and Layout assets
$baseUrl = "https://raw.githubusercontent.com/Amaan12/Amaan12PreferenceApplier/main/Unity"
$shortcutFileName = "Default copy.shortcut"
$layoutFileName = "2 by 3 - 2026.wlt"

function Deploy-File ($fileName, [string[]]$destPaths) {
    $localFile = if ($PSScriptRoot) {
        $unityPath = Join-Path $PSScriptRoot "Unity\$fileName"
        if (Test-Path $unityPath) { $unityPath } else { Join-Path $PSScriptRoot $fileName }
    } else { $null }
    $tempFile = $null

    if ($localFile -and (Test-Path $localFile)) {
        $sourcePath = $localFile
    } else {
        $encodedName = [System.Uri]::EscapeDataString($fileName)
        $url = "$baseUrl/$encodedName"
        $tempFile = [System.IO.Path]::GetTempFileName()
        Write-Host "  -> Fetching $fileName from GitHub..." -ForegroundColor Yellow
        Invoke-WebRequest -Uri $url -OutFile $tempFile -UseBasicParsing
        $sourcePath = $tempFile
    }

    foreach ($dest in $destPaths) {
        [System.IO.File]::Copy($sourcePath, $dest, $true)
    }

    if ($tempFile -and (Test-Path $tempFile)) {
        Remove-Item -Path $tempFile -Force -ErrorAction SilentlyContinue
    }
}

$destShortcut = Join-Path $shortcutDir $shortcutFileName
Deploy-File -fileName $shortcutFileName -destPaths @($destShortcut)

$destLayoutRoot = Join-Path $layoutRootDir $layoutFileName
$destLayoutDefault = Join-Path $layoutDefaultDir $layoutFileName
Deploy-File -fileName $layoutFileName -destPaths @($destLayoutRoot, $destLayoutDefault)

# 3. Apply Editor Preferences via Windows Registry
$regKey = [Microsoft.Win32.Registry]::CurrentUser.CreateSubKey("Software\Unity Technologies\Unity Editor 5.x")

# Playmode Tint (#E0FF53)
$regKey.SetValue("Playmode tint", "Playmode tint;0.8784314;1;0.3254902;1", [Microsoft.Win32.RegistryValueKind]::String)

# Scene View & Object Creation: Spawn at World Origin (0,0,0)
$regKey.SetValue("Create3DObject.PlaceAtWorldOrigin", 1, [Microsoft.Win32.RegistryValueKind]::DWord)
$regKey.SetValue("Create3DObject.PlacementMode", 1, [Microsoft.Win32.RegistryValueKind]::DWord)

# Scene View: 4x MSAA
$regKey.SetValue("SceneViewMSAALevel", 4, [Microsoft.Win32.RegistryValueKind]::DWord)

# Script Compilation: Recompile After Finished Playing
$regKey.SetValue("ScriptCompilationDuringPlay", 0, [Microsoft.Win32.RegistryValueKind]::DWord)

# Prefab Mode: Disable Auto-Save (Manual Save Only)
$regKey.SetValue("PrefabEditing.AutoSave", 0, [Microsoft.Win32.RegistryValueKind]::DWord)

# Hierarchy Window: No alternating rows, prompt to rename new objects
$regKey.SetValue("HierarchyWindow.AlternatingRowBackground", 0, [Microsoft.Win32.RegistryValueKind]::DWord)
$regKey.SetValue("SceneHierarchyWindow.RenameNewObjects", 1, [Microsoft.Win32.RegistryValueKind]::DWord)

# Active Shortcut Profile: 'Default copy'
$regKey.SetValue("ShortcutManagement_LastUsedShortcutProfileId_default", "Default copy", [Microsoft.Win32.RegistryValueKind]::String)

$regKey.Close()

# 4. Success summary
Write-Host "`n[Amaan12] Preferences applied successfully!" -ForegroundColor Green
Write-Host "  * Shortcuts: 'Default copy' (G: Move, R: Rotate, S: Scale, MMB: Orbit, Alt+MMB: Pan, F12: Fullscreen)" -ForegroundColor Gray
Write-Host "  * Colors: Lime Playmode Tint (#E0FF53)" -ForegroundColor Gray
Write-Host "  * Scene: Spawn at World Origin (0,0,0) & 4x MSAA" -ForegroundColor Gray
Write-Host "  * General: Recompile after playing & Manual Prefab Save" -ForegroundColor Gray
Write-Host "  * Hierarchy: Clean hierarchy (no alternating rows, prompt to rename)" -ForegroundColor Gray
Write-Host "  * Layout: '2 by 3 - 2026' installed to global Layouts menu`n" -ForegroundColor Gray
