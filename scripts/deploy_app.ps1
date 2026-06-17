# Build and Deploy script for Bharatiyam Grantha Sudha
# This script builds the Flutter Web App and copies the Admin Panel into the build output, then deploys to Firebase Hosting.

$ProjectRoot = "d:\bharatheeyam books"
Set-Location $ProjectRoot

Write-Host "Bharatiyam Gratha Sudha - Build & Deploy Tool" -ForegroundColor Yellow
Write-Host "=================================================" -ForegroundColor DarkYellow

# Step 1: Build the Flutter Web App
Write-Host "Step 1: Compiling Flutter Web App..." -ForegroundColor Cyan
flutter build web --release
if ($LASTEXITCODE -ne 0) {
    Write-Error "Flutter web build failed! Deployment aborted."
    exit $LASTEXITCODE
}
Write-Host "  Flutter Web App compiled successfully." -ForegroundColor Green

# Step 2: Copy Admin Panel files to the build output folder
Write-Host "Step 2: Injecting Admin Panel into build output..." -ForegroundColor Cyan
$AdminDest = Join-Path $ProjectRoot "build\web\admin"

# Ensure clean destination
if (Test-Path $AdminDest) {
    Remove-Item -Path $AdminDest -Recurse -Force | Out-Null
}

# Copy admin directory recursive
Copy-Item -Path (Join-Path $ProjectRoot "admin") -Destination $AdminDest -Recurse -Force
Write-Host "  Admin Panel copied to build/web/admin" -ForegroundColor Green

# Step 3: Deploy to Firebase Hosting
Write-Host "Step 3: Deploying to Firebase Hosting..." -ForegroundColor Cyan
firebase deploy --only hosting
if ($LASTEXITCODE -ne 0) {
    Write-Error "Firebase deployment failed."
    exit $LASTEXITCODE
}

Write-Host "Success! Both Flutter App (/) and Admin Panel (/admin/) are deployed." -ForegroundColor Green
Write-Host "=================================================" -ForegroundColor DarkYellow
