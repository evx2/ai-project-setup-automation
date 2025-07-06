# Repository Dependencies

This automation system depends on the following repositories that will be automatically cloned:

## Core Dependencies

### 1. Software-Engineer-AI-Agent-Atlas
- **Purpose**: Atlas brain template structure
- **Repository**: [Your Atlas repo URL here]
- **Local Path**: `.repos/Software-Engineer-AI-Agent-Atlas/`
- **Usage**: Template for creating new Atlas brain instances

### 2. WordPress-AI-Commander  
- **Purpose**: WordPress development patterns and tools
- **Repository**: [Your WordPress AI Commander repo URL here]
- **Local Path**: `.repos/WordPress-AI-Commander/`
- **Usage**: Optional WordPress project patterns in `includes/tools/`

### 3. Task-Master-AI
- **Purpose**: Task management integration
- **Repository**: [Your Task-Master repo URL here] 
- **Local Path**: `.repos/Task-Master-AI/`
- **Usage**: Task management initialization and workflows

## Auto-Clone Behavior

The setup scripts will automatically:
1. Check if repositories exist in `.repos/` folder
2. Git clone missing repositories on first run
3. Use existing repositories if already present
4. Skip cloning if repositories are up to date

## Repository Updates

To update repositories:
```bash
# Update all repos
./scripts/update-repos.sh

# Update specific repo
cd .repos/Software-Engineer-AI-Agent-Atlas && git pull
cd .repos/WordPress-AI-Commander && git pull  
cd .repos/Task-Master-AI && git pull
```

## Configuration

Repository URLs can be configured in:
- `scripts/repo-config.json` - Repository URLs and settings
- Environment variables for custom repository locations