# Push with Conversation Backup
# Usage: .\scripts\push_with_backup.ps1 "your commit message"

param(
    [Parameter(Mandatory=$false)]
    [string]$CommitMessage = "Update project"
)

$ProjectRoot = "d:\bharatheeyam books"
$ConvId = "9dd96f49-1b5d-49be-9d15-005bfbd79edd"
$BrainPath = "C:\Users\goure\.gemini\antigravity\brain\$ConvId"
$BackupDir = "$ProjectRoot\conversation_backup"
$Timestamp = Get-Date -Format "yyyyMMdd_HHmmss"

Write-Host "`n🕉️ Bharatiyam Gratha Sudha — Push with Backup" -ForegroundColor Yellow
Write-Host "=============================================" -ForegroundColor DarkYellow

# Step 1: Create backup directory
if (-not (Test-Path $BackupDir)) {
    New-Item -ItemType Directory -Path $BackupDir -Force | Out-Null
}

# Step 2: Copy conversation transcript
Write-Host "`n📋 Backing up conversation..." -ForegroundColor Cyan
$TranscriptSrc = "$BrainPath\.system_generated\logs\transcript.jsonl"
if (Test-Path $TranscriptSrc) {
    Copy-Item $TranscriptSrc "$BackupDir\transcript_$Timestamp.jsonl" -Force
    Copy-Item $TranscriptSrc "$BackupDir\transcript_latest.jsonl" -Force
    Write-Host "  ✅ Transcript backed up" -ForegroundColor Green
} else {
    Write-Host "  ⚠️ Transcript not found at $TranscriptSrc" -ForegroundColor Yellow
}

# Step 3: Copy artifacts (implementation plan, task, walkthrough)
$ArtifactFiles = @("implementation_plan.md", "task.md", "walkthrough.md")
foreach ($file in $ArtifactFiles) {
    $src = "$BrainPath\$file"
    if (Test-Path $src) {
        Copy-Item $src "$BackupDir\$file" -Force
        Write-Host "  ✅ $file backed up" -ForegroundColor Green
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
Write-Host "`n📦 Committing changes..." -ForegroundColor Cyan
Set-Location $ProjectRoot
git add -A
git commit -m "🕉️ $CommitMessage [$Timestamp]"

Write-Host "`n🚀 Pushing to GitHub..." -ForegroundColor Cyan
git push

Write-Host "`n✅ Done! Changes pushed with conversation backup." -ForegroundColor Green
Write-Host "=============================================" -ForegroundColor DarkYellow
