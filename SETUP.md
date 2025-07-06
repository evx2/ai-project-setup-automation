# Setup Guide

## Initial Configuration

Before using the AI Project Setup Automation, you need to configure the repository URLs in `scripts/config.sh`.

### 1. Configure Repository URLs

Edit `scripts/config.sh` and update the repository URLs:

```bash
REPOSITORIES=(
    "Software-Engineer-AI-Agent-Atlas|https://github.com/syahiidkamil/Software-Engineer-AI-Agent-Atlas.git|true|Atlas brain template structure"
    "ai-command|https://github.com/mcp-wp/ai-command.git|false|WordPress development patterns and tools"
    "claude-task-master|https://github.com/eyaltoledano/claude-task-master.git|false|Task management integration"
)
```

These are the actual repositories that will be cloned automatically.

### 2. Repository Requirements

#### Required Repository:
- **Software-Engineer-AI-Agent-Atlas**: This is required and must exist
  - Contains the Atlas brain template structure
  - Must have a CLAUDE.md file and basic Atlas structure

#### Optional Repositories:
- **ai-command**: Only needed for WordPress projects
  - Contains WordPress development patterns in `includes/tools/`
- **claude-task-master**: For task management integration
  - Used for task-master initialization

### 3. Installation Options

#### Option A: Direct Usage
```bash
# Navigate to the project
cd /path/to/ai-project-setup-automation

# Run the script
./scripts/new-project.sh my-project-name
```

#### Option B: Install to System
```bash
# Install to default location (~/.claude/.scripts)
./install.sh

# Or install to custom location
./install.sh /custom/path/.scripts
```

### 4. First Run

On first run, the script will:
1. Check if required repositories exist in `.claude/.repos/`
2. Clone missing repositories automatically
3. Proceed with project creation

### 5. Directory Structure Created

```
.claude/
├── .repos/                                    # Auto-cloned repositories
│   ├── Software-Engineer-AI-Agent-Atlas/     # Required template
│   ├── ai-command/                           # Optional WordPress patterns  
│   └── claude-task-master/                   # Optional task management
├── atlas/
│   └── atlas-{project-name}/                 # Your project brain
└── docs-projects/
    └── docs-theme-{project-name}/            # Centralized documentation
```

### 6. Customization

You can add more repositories by adding entries to the `REPOSITORIES` array in `config.sh`:

```bash
REPOSITORIES=(
    # Existing entries...
    "Your-Custom-Repo|https://github.com/you/your-repo.git|false|Your custom description"
)
```

### 7. Troubleshooting

#### Repository Clone Failures
- Check that repository URLs are correct in `config.sh`
- Ensure you have access to the repositories (public or proper authentication)
- Check internet connectivity

#### Permission Issues
- Make sure scripts are executable: `chmod +x scripts/*.sh`
- On Windows, run from Git Bash or WSL

#### Junction Creation Issues
- On Windows, ensure you're running with appropriate permissions
- PowerShell execution policy may need adjustment

### 8. Updates

To update repositories later:
```bash
cd .claude/.repos/Software-Engineer-AI-Agent-Atlas && git pull
cd .claude/.repos/ai-command && git pull
cd .claude/.repos/claude-task-master && git pull
```

Or create an update script to automate this process.