# AI Project Setup Automation

![Windows](https://img.shields.io/badge/Windows-10%2B-blue.svg)
![License](https://img.shields.io/badge/License-GPLv3-orange.svg)

Automated project setup scripts for creating AI agent brain structures with Windows junction links to centralized documentation.

## Overview

This project provides cross-platform automation for:
- Creating Atlas brain project structures
- Setting up centralized documentation in `docs-projects/`
- Creating Windows junctions for convenient access
- Initializing Task-Master integration
- WordPress project pattern setup

## Features

✅ **Dynamic Path Detection** - No hardcoded paths, works from any location
✅ **Windows Junction Creation** - Uses PowerShell for reliable junction creation  
✅ **Cross-Platform Support** - Both Bash (.sh) and PowerShell (.ps1) versions
✅ **Atlas Brain Integration** - Complete Software Engineer AI Agent Atlas setup
✅ **Documentation Organization** - Centralized docs with convenient Atlas access
✅ **Task-Master Integration** - Automatic task management setup
✅ **WordPress Patterns** - Automatic WordPress development patterns via parameter
✅ **Parameter-based Setup** - WordPress projects via `wordpress` or `wp` parameter

## Summary

This automation system streamlines the creation of AI agent brain projects by:
- Auto-cloning required repositories from GitHub
- Creating standardized Atlas brain structures  
- Setting up Windows junction links for convenient documentation access
- Integrating task management and WordPress development patterns
- Providing cross-platform compatibility (Bash + PowerShell)

## Installation

### Option 1: Direct Usage
```bash
# Clone this repository
git clone https://github.com/evx2/ai-project-setup-automation.git
cd ai-project-setup-automation

# Configure repository URLs in scripts/config.sh
# Then run directly
./scripts/new-project.sh my-project-name
```

### Option 2: System Installation  
```bash
# Install to default location (~/.claude/.scripts)
./install.sh

# Or install to custom location
./install.sh /custom/path/.scripts
```

## Usage

### Bash (Linux/WSL)
```bash
# Regular project
./scripts/new-project.sh my-project-name

# WordPress project (automatically includes WP reference library)
./scripts/new-project.sh my-project-name wordpress
./scripts/new-project.sh my-project-name wp          # Short form
```

### PowerShell (Windows)
```powershell
.\scripts\new-project.ps1 -ProjectName "my-project-name"
```

## Project Structure Created

```
.claude/
├── atlas/
│   └── atlas-{project-name}/          # Atlas brain
│       ├── current/                   # → Junction to docs-projects
│       ├── development/               # → Junction to docs-projects  
│       ├── sessions/                  # → Junction to docs-projects
│       ├── archive/                   # → Junction to docs-projects
│       ├── CLAUDE.md                  # Atlas brain configuration
│       ├── CURRENT_STATE.md           # Project status
│       ├── TODOS_ACTIVE.md            # Active tasks
│       └── QUICK_RESUME.md            # Resume instructions
└── docs-projects/
    └── docs-theme-{project-name}/     # Real documentation storage
        ├── current/                   # Current project docs
        ├── development/               # Development notes
        ├── sessions/                  # Session logs  
        ├── archive/                   # Archived materials
        ├── historical/                # Historical versions
        ├── backups/                   # Backup files
        ├── specifications/            # Project specs
        └── research/                  # Research materials
```

## Junction System

The scripts create Windows junctions that provide:
- **Convenient Access**: Access docs from Atlas brain location
- **Centralized Storage**: Real files stored in `docs-projects/`
- **Cross-Reference**: Multiple projects can reference shared docs
- **Organization**: Clean separation between brain and documentation

## Requirements

- **Bash Version**: WSL, Linux, or Git Bash
- **PowerShell Version**: Windows PowerShell 5.0+
- **Optional**: Node.js + npm (for Task-Master)
- **Optional**: WordPress patterns repository

## File Descriptions

### Scripts
- `scripts/new-project.sh` - Bash version with dynamic path detection
- `scripts/new-project.ps1` - PowerShell version with native junction creation

### Documentation  
- `docs/AUTOMATED_SETUP_GUIDE.md` - Complete setup documentation
- `docs/TODAY_SUMMARY.md` - Development progress summary

### Templates
- `templates/` - Template files for project initialization

## Recent Fixes

### Junction Creation Issue Resolution
- **Problem**: `mklink` command syntax issues
- **Solution**: Switched to PowerShell `New-Item -ItemType Junction`
- **Result**: 100% reliable junction creation

### Dynamic Path Detection
- **Problem**: Hardcoded paths in bash script
- **Solution**: Script-relative path calculation
- **Result**: Works from any directory structure

## Usage Examples

### Create a new web project
```bash
./scripts/new-project.sh my-website
```

### Create a WordPress project
```bash
# Automatically includes WordPress reference patterns
./scripts/new-project.sh wp-project wordpress
./scripts/new-project.sh wp-project wp        # Short form
```

### Resume an existing project
```bash
# Use the path shown in QUICK_RESUME.md
./.claude/.scripts/session.sh my-project resume
```

## Integration Notes

- Works with existing Atlas brain repositories
- Compatible with Task-Master AI task management
- Supports WordPress AI Commander patterns  
- Integrates with Claude Code documentation system

## Testing

The scripts have been tested with:
- ✅ Junction creation and functionality
- ✅ Dynamic path detection
- ✅ Cross-platform compatibility
- ✅ Atlas brain template copying
- ✅ Documentation structure creation

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly on your Windows system
5. Submit a pull request

When adding features:
- Test both bash and PowerShell versions
- Ensure dynamic path detection works
- Verify junction creation on Windows
- Update documentation
- Test with different project names

## Author

Created for the Windows power user community by developers who understand the need for efficient project automation.

## License

GPLv3

---

**⭐ If this utility saved you time, please star the repository!**

## 💖 Support This Project

If this tool has made your Windows experience smoother, consider supporting its continued development!

**Buy me a coffee!**

[![Ko-fi](https://img.shields.io/badge/Ko--fi-F16061?style=for-the-badge&logo=ko-fi&logoColor=white)](https://techreader.com/ko-fi)
[![PayPal](https://img.shields.io/badge/PayPal-00457C?style=for-the-badge&logo=paypal&logoColor=white)](https://techreader.com/paypal)

**Why donate?**
- ☕ Fuel more utility development
- 🚀 Support new Windows tools and improvements  
- 🐛 Faster bug fixes and updates
- 📚 Better documentation and tutorials

**Even small contributions make a big difference!** Every coffee helps keep this project actively maintained and growing.

---

*Made with ❤️ for the Windows power user community*