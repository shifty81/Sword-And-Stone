# PowerShell script to download Zylann.Voxel GDExtension binaries for Windows
# Run this script to add Windows support to the addon

$ErrorActionPreference = "Stop"

$ADDON_DIR = Split-Path -Parent $MyInvocation.MyCommand.Path
$BIN_DIR = Join-Path $ADDON_DIR "bin"
$TEMP_DIR = Join-Path $env:TEMP "godot_voxel_download"

Write-Host "=== Zylann.Voxel Windows Binaries Downloader ===" -ForegroundColor Cyan
Write-Host ""
Write-Host "This script downloads the Windows x86_64 binaries for the Zylann.Voxel GDExtension."
Write-Host "These binaries are required to use the addon on Windows systems."
Write-Host ""

# Check if binaries already exist
$editorDll = Join-Path $BIN_DIR "libvoxel.windows.editor.x86_64.dll"
$releaseDll = Join-Path $BIN_DIR "libvoxel.windows.template_release.x86_64.dll"

if (Test-Path $editorDll) {
    Write-Host "✓ Windows binaries already present!" -ForegroundColor Green
    Write-Host "  - libvoxel.windows.editor.x86_64.dll"
    if (Test-Path $releaseDll) {
        Write-Host "  - libvoxel.windows.template_release.x86_64.dll"
    }
    Write-Host ""
    $response = Read-Host "Do you want to re-download and overwrite? (y/N)"
    if ($response -notmatch "^[Yy]$") {
        Write-Host "Keeping existing binaries."
        exit 0
    }
}

# Create temp directory
New-Item -ItemType Directory -Force -Path $TEMP_DIR | Out-Null
Push-Location $TEMP_DIR

try {
    Write-Host "Fetching latest release information..." -ForegroundColor Yellow
    
    # Get latest release from GitHub
    $releases = Invoke-RestMethod -Uri "https://api.github.com/repos/Zylann/godot_voxel/releases"
    
    # Find Windows binary URL
    $releaseUrl = $null
    foreach ($release in $releases) {
        foreach ($asset in $release.assets) {
            if ($asset.name -match "windows.*x86_64.*\.zip" -or $asset.name -match "x86_64.*windows.*\.zip") {
                $releaseUrl = $asset.browser_download_url
                break
            }
        }
        if ($releaseUrl) { break }
    }
    
    if (-not $releaseUrl) {
        Write-Host "ERROR: Could not find Windows binaries in releases." -ForegroundColor Red
        Write-Host "Release naming may have changed or no Windows binaries available."
        Write-Host "Please download manually from: https://github.com/Zylann/godot_voxel/releases"
        exit 1
    }
    
    Write-Host "Found release: $releaseUrl" -ForegroundColor Green
    Write-Host "Downloading..." -ForegroundColor Yellow
    
    $zipFile = "godot_voxel_windows.zip"
    Invoke-WebRequest -Uri $releaseUrl -OutFile $zipFile
    
    Write-Host "Extracting..." -ForegroundColor Yellow
    Expand-Archive -Path $zipFile -DestinationPath . -Force
    
    # Find and copy the .dll files
    Write-Host "Installing binaries..." -ForegroundColor Yellow
    $dllFiles = Get-ChildItem -Recurse -Filter "libvoxel.windows.*.dll"
    
    if ($dllFiles.Count -eq 0) {
        Write-Host "ERROR: No Windows .dll files found in downloaded archive" -ForegroundColor Red
        Write-Host "Archive structure may have changed."
        exit 1
    }
    
    foreach ($file in $dllFiles) {
        Write-Host "Installing: $($file.Name)" -ForegroundColor Green
        Copy-Item $file.FullName -Destination $BIN_DIR -Force
    }
    
    Write-Host ""
    Write-Host "=== Installation Complete ===" -ForegroundColor Green
    Write-Host ""
    Write-Host "Windows binaries installed to: $BIN_DIR"
    Get-ChildItem -Path $BIN_DIR -Filter "libvoxel.windows.*.dll" | ForEach-Object {
        Write-Host "  ✓ $($_.Name)" -ForegroundColor Green
    }
    Write-Host ""
    Write-Host "The addon should now work on Windows systems with Godot 4.4.1+"
    Write-Host "Restart Godot to activate the changes."
    
} catch {
    Write-Host "ERROR: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
} finally {
    Pop-Location
    Remove-Item -Recurse -Force $TEMP_DIR -ErrorAction SilentlyContinue
}
