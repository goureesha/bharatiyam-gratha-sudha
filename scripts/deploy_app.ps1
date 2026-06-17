# Build and Deploy script for Bharatiyam Grantha Sudha
# This script builds the Flutter Web App and copies the Admin Panel into the build output, then deploys to Firebase Hosting.

$ProjectRoot = Split-Path -Parent $PSScriptRoot
Set-Location $ProjectRoot

Write-Host "Bharatiyam Gratha Sudha - Build & Deploy Tool" -ForegroundColor Yellow
Write-Host "=================================================" -ForegroundColor DarkYellow

# Step 1: Build the Flutter Web App
Write-Host "Step 1: Compiling Flutter Web App..." -ForegroundColor Cyan
if (Get-Command flutter -ErrorAction SilentlyContinue) {
    flutter build web --release
    if ($LASTEXITCODE -ne 0) {
        Write-Error "Flutter web build failed! Deployment aborted."
        exit $LASTEXITCODE
    }
    Write-Host "  Flutter Web App compiled successfully." -ForegroundColor Green
} else {
    Write-Host "  WARNING: 'flutter' command not found on this system's PATH." -ForegroundColor Yellow
    Write-Host "  Skipping Flutter compilation. Will attempt to deploy existing build/web folder if it exists." -ForegroundColor Yellow
}

# Step 2: Copy Admin Panel files to the build output folder
Write-Host "Step 2: Injecting Admin Panel into build output..." -ForegroundColor Cyan
$AdminDest = Join-Path $ProjectRoot "build\web\admin"

# Ensure build/web folder exists if we skipped flutter build
if (-not (Test-Path (Join-Path $ProjectRoot "build\web"))) {
    New-Item -ItemType Directory -Path (Join-Path $ProjectRoot "build\web") -Force | Out-Null
}

# Ensure clean destination
if (Test-Path $AdminDest) {
    Remove-Item -Path $AdminDest -Recurse -Force | Out-Null
}

# Copy admin directory recursive
Copy-Item -Path (Join-Path $ProjectRoot "admin") -Destination $AdminDest -Recurse -Force
Write-Host "  Admin Panel copied to build/web/admin" -ForegroundColor Green

# Step 3: Deploy to Firebase Hosting
Write-Host "Step 3: Deploying to Firebase Hosting..." -ForegroundColor Cyan
if (Get-Command firebase -ErrorAction SilentlyContinue) {
    firebase deploy --only hosting
    if ($LASTEXITCODE -ne 0) {
        Write-Error "Firebase deployment failed."
        exit $LASTEXITCODE
    }
} else {
    Write-Error "Firebase CLI ('firebase' command) is not installed or not in PATH."
    exit 1
}

Write-Host "Success! Both Flutter App (/) and Admin Panel (/admin/) are deployed." -ForegroundColor Green
Write-Host "=================================================" -ForegroundColor DarkYellow
