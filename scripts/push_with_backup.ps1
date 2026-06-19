# Push with Conversation Backup
# Usage: .\scripts\push_with_backup.ps1 "your commit message"

param(
    [Parameter(Mandatory=$false)]
    [string]$CommitMessage = "Update project"
)

$ProjectRoot = Split-Path -Parent $PSScriptRoot
$ConvId = "fcebfe0c-6765-4c98-b670-f333b885c095"
$BrainPath = "C:\Users\goure\.gemini\antigravity\brain\$ConvId"
$BackupDir = "$ProjectRoot\conversation_backup"
$Timestamp = Get-Date -Format "yyyyMMdd_HHmmss"

Write-Host "Bharatiyam Gratha Sudha - Push with Backup" -ForegroundColor Yellow
Write-Host "=============================================" -ForegroundColor DarkYellow

# Step 1: Create backup directory
if (-not (Test-Path $BackupDir)) {
    New-Item -ItemType Directory -Path $BackupDir -Force | Out-Null
}

# Step 2: Copy conversation transcript
Write-Host "Backing up conversation..." -ForegroundColor Cyan
$TranscriptSrc = "$BrainPath\.system_generated\logs\transcript.jsonl"
if (Test-Path $TranscriptSrc) {
    Copy-Item $TranscriptSrc "$BackupDir\transcript_$Timestamp.jsonl" -Force
    Copy-Item $TranscriptSrc "$BackupDir\transcript_latest.jsonl" -Force
    Write-Host "  Transcript backed up" -ForegroundColor Green
} else {
    Write-Host "  Transcript not found at $TranscriptSrc" -ForegroundColor Yellow
}

# Step 3: Copy artifacts (implementation plan, task, walkthrough)
$ArtifactFiles = @("implementation_plan.md", "task.md", "walkthrough.md")
foreach ($file in $ArtifactFiles) {
    $src = "$BrainPath\$file"
    if (Test-Path $src) {
        Copy-Item $src "$BackupDir\$file" -Force
        Write-Host "  $file backed up" -ForegroundColor Green
    }
}

# Step 4: Write backup metadata
$metadata = @{
    timestamp = $Timestamp
    commit_message = $CommitMessage
    conversation_id = $ConvId
} | ConvertTo-Json
$metadata | Out-File "$BackupDir\backup_meta.json" -Encoding UTF8 -Force

# Step 5: Git add, commit, push
Write-Host "Committing changes..." -ForegroundColor Cyan
Set-Location $ProjectRoot
git add -A
git commit -m "Update: $CommitMessage [$Timestamp]"

Write-Host "Pushing to GitHub..." -ForegroundColor Cyan
git push

Write-Host "Done! Changes pushed with conversation backup." -ForegroundColor Green
Write-Host "=============================================" -ForegroundColor DarkYellow
