# Build and Deploy script for Bharatiyam Grantha Sudha
# Usage: 
#   .\scripts\deploy_app.ps1 -Target "admin"  (Deploy the admin panel only - Default)
#   .\scripts\deploy_app.ps1 -Target "app"    (Build and deploy the Flutter App only)
#   .\scripts\deploy_app.ps1 -Target "both"   (Deploy both admin and app)

param(
    [Parameter(Mandatory=$false)]
    [ValidateSet("admin", "app", "both")]
    [string]$Target = "admin"
)

$ProjectRoot = Split-Path -Parent $PSScriptRoot
Set-Location $ProjectRoot

Write-Host "Bharatiyam Gratha Sudha - Build & Deploy Tool" -ForegroundColor Yellow
Write-Host "=================================================" -ForegroundColor DarkYellow
Write-Host "Target selected: $Target" -ForegroundColor Cyan

# Step 1: Deploy Admin Website
if ($Target -eq "admin" -or $Target -eq "both") {
    Write-Host "`n🚀 Step 1: Deploying Admin Website to separate hosting site..." -ForegroundColor Cyan
    if (Get-Command firebase -ErrorAction SilentlyContinue) {
        firebase deploy --only hosting:bharatiyam-grantha-sudha-admin
        if ($LASTEXITCODE -ne 0) {
            Write-Error "Admin Website deployment failed."
            exit $LASTEXITCODE
        }
        Write-Host "  Admin Website deployed successfully to: https://bharatiyam-grantha-sudha-admin.web.app" -ForegroundColor Green
    } else {
        Write-Error "Firebase CLI ('firebase' command) is not installed or not in PATH."
        exit 1
    }
}

# Step 2: Build & Deploy Flutter App
if ($Target -eq "app" -or $Target -eq "both") {
    Write-Host "`n🚀 Step 2: Compiling Flutter Web App..." -ForegroundColor Cyan
    if (Get-Command flutter -ErrorAction SilentlyContinue) {
        flutter build web --release
        if ($LASTEXITCODE -ne 0) {
            Write-Error "Flutter web build failed! Deployment aborted."
            exit $LASTEXITCODE
        }
        Write-Host "  Flutter Web App compiled successfully." -ForegroundColor Green
        
        Write-Host "Deploying Flutter Web App to main hosting site..." -ForegroundColor Cyan
        firebase deploy --only hosting:bharatiyam-grantha-sudha
        if ($LASTEXITCODE -ne 0) {
            Write-Error "Flutter Web App deployment failed."
            exit $LASTEXITCODE
        }
        Write-Host "  Flutter Web App deployed successfully to: https://bharatiyam-grantha-sudha.web.app" -ForegroundColor Green
    } else {
        Write-Error "'flutter' command not found. Cannot compile or deploy the main app."
        exit 1
    }
}

Write-Host "`n=================================================" -ForegroundColor DarkYellow
Write-Host "Deployment completed!" -ForegroundColor Green
