# Build and Deploy script for Bharatiyam Grantha Sudha Flutter Web App
# Usage: 
#   .\scripts\deploy_app.ps1

$ProjectRoot = Split-Path -Parent $PSScriptRoot
Set-Location $ProjectRoot

Write-Host "Bharatiyam Gratha Sudha - Build & Deploy Tool" -ForegroundColor Yellow
Write-Host "=================================================" -ForegroundColor DarkYellow

# Step 1: Build Flutter Web App
Write-Host "`n🚀 Step 1: Compiling Flutter Web App..." -ForegroundColor Cyan
if (Get-Command flutter -ErrorAction SilentlyContinue) {
    flutter build web --release
    if ($LASTEXITCODE -ne 0) {
        Write-Error "Flutter web build failed! Deployment aborted."
        exit $LASTEXITCODE
    }
    Write-Host "  Flutter Web App compiled successfully." -ForegroundColor Green
    
    # Step 2: Deploy to Firebase Hosting
    Write-Host "`n🚀 Step 2: Deploying Flutter Web App to main hosting site..." -ForegroundColor Cyan
    if (Get-Command firebase -ErrorAction SilentlyContinue) {
        firebase deploy --only hosting
        if ($LASTEXITCODE -ne 0) {
            Write-Error "Flutter Web App deployment failed."
            exit $LASTEXITCODE
        }
        Write-Host "  Flutter Web App deployed successfully to: https://bharatiyam-grantha-sudha.web.app" -ForegroundColor Green
    } else {
        Write-Error "Firebase CLI ('firebase' command) is not installed or not in PATH."
        exit 1
    }
} else {
    Write-Error "'flutter' command not found. Cannot compile or deploy the main app."
    exit 1
}

Write-Host "`n=================================================" -ForegroundColor DarkYellow
Write-Host "Deployment completed!" -ForegroundColor Green
