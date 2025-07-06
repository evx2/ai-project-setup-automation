# New Project Setup Script
# Usage: .\new-project.ps1 -ProjectName "my-project"

param(
    [Parameter(Mandatory=$true)]
    [string]$ProjectName
)

# Get current script location dynamically
$ScriptPath = Split-Path -Parent $MyInvocation.MyCommand.Path
$RootPath = Split-Path -Parent (Split-Path -Parent $ScriptPath)
$AtlasPath = "$RootPath\.claude\atlas\atlas-$ProjectName"
$DocsPath = "$RootPath\.claude\docs-projects\docs-theme-$ProjectName"
$AtlasTemplate = "$RootPath\.claude\.repos\Software-Engineer-AI-Agent-Atlas"

Write-Host "🚀 Creating new project: $ProjectName" -ForegroundColor Green

# 1. Create Atlas brain structure
Write-Host "📁 Creating Atlas brain structure..." -ForegroundColor Yellow
if (Test-Path $AtlasTemplate) {
    Copy-Item -Path $AtlasTemplate -Destination $AtlasPath -Recurse -Force
    Write-Host "✅ Atlas brain created at: $AtlasPath" -ForegroundColor Green
} else {
    Write-Error "❌ Atlas template not found at: $AtlasTemplate"
    exit 1
}

# 2. Create project documentation structure
Write-Host "📁 Creating project documentation structure..." -ForegroundColor Yellow
$DocsFolders = @("current", "development", "sessions", "working-logs", "archive", "historical")
foreach ($folder in $DocsFolders) {
    $folderPath = "$DocsPath\$folder"
    New-Item -ItemType Directory -Path $folderPath -Force | Out-Null
}
Write-Host "✅ Project docs created at: $DocsPath" -ForegroundColor Green

# 3. Create Windows junctions
Write-Host "🔗 Creating Windows junctions..." -ForegroundColor Yellow
$JunctionPairs = @(
    @("current", "current"),
    @("development", "development"), 
    @("sessions", "sessions"),
    @("archive", "archive")
)

foreach ($pair in $JunctionPairs) {
    $linkPath = "$AtlasPath\$($pair[0])"
    $targetPath = "$DocsPath\$($pair[1])"
    
    # Remove if exists
    if (Test-Path $linkPath) {
        Remove-Item $linkPath -Force -Recurse
    }
    
    # Create junction using PowerShell New-Item (more reliable)
    try {
        $result = New-Item -ItemType Junction -Path $linkPath -Target $targetPath -Force 2>&1
        if (Test-Path $linkPath) {
            Write-Host "✅ Junction created: $($pair[0])" -ForegroundColor Green
        } else {
            Write-Host "❌ Failed to create junction: $($pair[0])" -ForegroundColor Red
            Write-Host "   Error: $result" -ForegroundColor Red
            Write-Host "   Link: $linkPath" -ForegroundColor Red
            Write-Host "   Target: $targetPath" -ForegroundColor Red
        }
    } catch {
        Write-Host "❌ Exception creating junction: $($pair[0])" -ForegroundColor Red
        Write-Host "   Error: $($_.Exception.Message)" -ForegroundColor Red
    }
}

# 4. Create initial files
Write-Host "📝 Creating initial project files..." -ForegroundColor Yellow

# Create CURRENT_STATE.md
$currentStateContent = @"
# $ProjectName - Current State

## Working Directory
```
[Add your project working directory path here]
```

## Environment Status
- **Status**: New project initialization
- **Local URL**: [Add local development URL]
- **Database**: [Add database info if applicable]

## Current Focus
- Setting up development environment
- Initializing project structure

## Last Updated
$(Get-Date -Format "yyyy-MM-dd HH:mm")
"@

Set-Content -Path "$AtlasPath\CURRENT_STATE.md" -Value $currentStateContent

# Create TODOS_ACTIVE.md
$todosContent = @"
# $ProjectName - Active TODOs

## Current Session Tasks
- [ ] Complete project environment setup
- [ ] Define project requirements
- [ ] Set up development workflow

## Next Steps
- [ ] [Add your first development tasks here]

## Blocked Items
- None

## Last Updated
$(Get-Date -Format "yyyy-MM-dd HH:mm")
"@

Set-Content -Path "$AtlasPath\TODOS_ACTIVE.md" -Value $todosContent

# Create QUICK_RESUME.md
$quickResumeContent = @"
# Quick Resume - $ProjectName

## To Resume This Project:

```bash
# From /mnt/c/root directory:
./.claude/.scripts/session.sh $ProjectName resume
```

## Then Read These Files:
1. ``$RootPath\.claude\atlas\atlas-$ProjectName\CURRENT_STATE.md``
2. ``$RootPath\.claude\atlas\atlas-$ProjectName\TODOS_ACTIVE.md``

## Quick Context:
- **What:** [Describe your project]
- **Where:** [Add working directory path]
- **Current Status:** New project setup
- **Last Work:** $(Get-Date -Format "yyyy-MM-dd") - Initial project creation

## Key Commands:
```bash
# Navigate to project
cd [your-project-working-directory]

# View project
# Browser: [your-local-url]

# Check status
git status
```

## Main Files:
- [Add main project files as you develop]
"@

Set-Content -Path "$AtlasPath\QUICK_RESUME.md" -Value $quickResumeContent

Write-Host "✅ Initial project files created" -ForegroundColor Green

# 5. Initialize Task-Master
Write-Host "🔧 Setting up Task-Master..." -ForegroundColor Yellow
Set-Location $AtlasPath
try {
    # Check if task-master is installed globally
    $taskMasterInstalled = Get-Command "task-master" -ErrorAction SilentlyContinue
    if (-not $taskMasterInstalled) {
        Write-Host "📦 Installing Task-Master globally..." -ForegroundColor Yellow
        npm install -g task-master-ai
    }
    
    # Initialize task-master in project
    task-master init
    Write-Host "✅ Task-Master initialized" -ForegroundColor Green
} catch {
    Write-Host "⚠️  Task-Master setup failed - you may need to install it manually:" -ForegroundColor Yellow
    Write-Host "   npm install -g task-master-ai" -ForegroundColor White
    Write-Host "   cd $AtlasPath && task-master init" -ForegroundColor White
}

# 6. Copy WordPress patterns (if WP project)
$isWordPress = Read-Host "Is this a WordPress project? (y/N)"
if ($isWordPress -eq "y" -or $isWordPress -eq "Y") {
    Write-Host "📁 Setting up WordPress patterns..." -ForegroundColor Yellow
    $wpPatternsSource = "$RootPath\.claude\.repos\WordPress-AI-Commander\includes\tools"
    $wpPatternsTarget = "$AtlasPath\scripts\wordpress-patterns"
    
    if (Test-Path $wpPatternsSource) {
        Copy-Item -Path $wpPatternsSource -Destination $wpPatternsTarget -Recurse -Force
        Write-Host "✅ WordPress patterns copied" -ForegroundColor Green
    } else {
        Write-Host "⚠️  WordPress patterns not found at: $wpPatternsSource" -ForegroundColor Yellow
    }
}

# 7. Update session.sh script
Write-Host "🔧 Updating session.sh script..." -ForegroundColor Yellow
$sessionScriptPath = "$RootPath\.claude\.scripts\session.sh"
if (Test-Path $sessionScriptPath) {
    Write-Host "ℹ️  Note: You may need to manually add '$ProjectName' to session.sh for resume functionality" -ForegroundColor Cyan
}

# 6. Final verification
Write-Host "🔍 Verifying setup..." -ForegroundColor Yellow
$verification = @()
if (Test-Path "$AtlasPath\CLAUDE.md") { $verification += "✅ Atlas brain" }
if (Test-Path "$DocsPath\current") { $verification += "✅ Project docs" }
if (Test-Path "$AtlasPath\current") { $verification += "✅ Junctions" }

Write-Host ""
Write-Host "🎉 Project '$ProjectName' created successfully!" -ForegroundColor Green
Write-Host ""
Write-Host "📍 Atlas Brain: $AtlasPath" -ForegroundColor Cyan
Write-Host "📍 Project Docs: $DocsPath" -ForegroundColor Cyan
Write-Host ""
Write-Host "Verification:" -ForegroundColor Yellow
$verification | ForEach-Object { Write-Host "  $_" -ForegroundColor Green }
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Yellow
Write-Host "1. Update CURRENT_STATE.md with your project details" -ForegroundColor White
Write-Host "2. Add your working directory path" -ForegroundColor White
Write-Host "3. Start developing!" -ForegroundColor White