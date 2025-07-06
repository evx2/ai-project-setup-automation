#!/bin/bash
# New Project Setup Script (Bash version)
# Usage: ./new-project.sh project-name [wordpress|wp]

PROJECT_NAME="$1"
IS_WORDPRESS="$2"

# Get current script location dynamically
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Determine root path - allow override via environment variable
if [ -n "$PROJECT_ROOT_PATH" ]; then
    ROOT_PATH="$PROJECT_ROOT_PATH"
else
    # Default: use the directory where this automation project is located
    # Go up from scripts directory to project root
    AUTOMATION_ROOT="$(dirname "$(dirname "$SCRIPT_DIR")")"
    ROOT_PATH="$AUTOMATION_ROOT"
    echo "⚠️  Using automation project directory for test installation: $ROOT_PATH"
fi

echo "📍 Using root path: $ROOT_PATH"
REPOS_PATH="$ROOT_PATH/.claude/.repos"
ATLAS_PATH="$ROOT_PATH/.claude/atlas/atlas-$PROJECT_NAME"
DOCS_PATH="$ROOT_PATH/.claude/docs-projects/docs-theme-$PROJECT_NAME"

# Load repository configuration
source "$SCRIPT_DIR/config.sh"

ATLAS_TEMPLATE="$REPOS_PATH/Software-Engineer-AI-Agent-Atlas"

# Function to clone repository if it doesn't exist
clone_repo_if_needed() {
    local repo_name="$1"
    local repo_url="$2"
    local repo_path="$REPOS_PATH/$repo_name"
    
    if [ ! -d "$repo_path" ]; then
        echo "📦 Cloning $repo_name repository..."
        mkdir -p "$REPOS_PATH"
        if git clone "$repo_url" "$repo_path"; then
            echo "✅ $repo_name cloned successfully"
        else
            echo "⚠️  Failed to clone $repo_name from $repo_url"
            echo "   You may need to update the repository URL in config.sh"
            return 1
        fi
    else
        echo "✅ $repo_name repository already exists"
    fi
    return 0
}

# Function to ensure all required repositories are available
ensure_repositories() {
    echo "🔍 Checking repository dependencies..."
    
    for repo in "${REPOSITORIES[@]}"; do
        IFS='|' read -r name url required description <<< "$repo"
        
        if [ "$required" = "true" ]; then
            if ! clone_repo_if_needed "$name" "$url"; then
                echo "❌ Failed to clone required repository: $name"
                echo "   Please check the repository URL in config.sh"
                return 1
            fi
        else
            clone_repo_if_needed "$name" "$url" || true
        fi
    done
    
    echo "✅ Repository dependencies satisfied"
    return 0
}

if [ -z "$PROJECT_NAME" ]; then
    echo "❌ Error: Project name required"
    echo "Usage: ./new-project.sh project-name [wordpress|wp]"
    exit 1
fi

echo "🚀 Creating new project: $PROJECT_NAME"

# 0. Ensure repository dependencies are available
if ! ensure_repositories; then
    echo "❌ Repository setup failed. Cannot continue."
    exit 1
fi

# 1. Create AI agent brain structure
echo "📁 Creating AI agent brain structure..."
echo "🔍 Looking for template at: $ATLAS_TEMPLATE"
if [ -d "$ATLAS_TEMPLATE" ]; then
    # Create parent directory if it doesn't exist
    mkdir -p "$(dirname "$ATLAS_PATH")"
    cp -r "$ATLAS_TEMPLATE" "$ATLAS_PATH"
    echo "✅ AI agent brain created at: $ATLAS_PATH"
else
    echo "❌ Brain template not found at: $ATLAS_TEMPLATE"
    exit 1
fi

# 2. Create project documentation structure
echo "📁 Creating project documentation structure..."
mkdir -p "$DOCS_PATH"/{current,development,sessions,archive,historical,backups,specifications,research}
echo "✅ Project docs created at: $DOCS_PATH"

# 3. Create Windows junctions in Atlas pointing to docs-projects
echo "🔗 Creating Windows junctions..."
declare -a junctions=("current" "development" "sessions" "archive")

for junction in "${junctions[@]}"; do
    link_path="$ATLAS_PATH/$junction"     # Junction in Atlas
    target_path="$DOCS_PATH/$junction"    # Real folder in docs-projects
    
    # Convert WSL paths to Windows paths (only for existing paths)
    # Convert the parent directories first
    atlas_parent_win=$(wslpath -w "$ATLAS_PATH")
    target_win=$(wslpath -w "$target_path")
    
    # Remove existing junction if it exists
    if [ -e "$link_path" ]; then
        rm -rf "$link_path"
    fi
    
    # Execute Windows PowerShell junction creation (more reliable than mklink)
    result=$(powershell.exe -Command "New-Item -ItemType Junction -Path '$atlas_parent_win\\$junction' -Target '$target_win'" 2>&1)
    
    if echo "$result" | grep -q "junction" || [ -e "$link_path" ]; then
        echo "✅ Junction created: atlas/$junction → docs-projects/$junction"
    else
        echo "❌ Failed to create junction: $junction"
        echo "   Error: $result"
        echo "   Link: $atlas_parent_win\\$junction"
        echo "   Target: $target_win"
    fi
done

# 4. Create initial files
echo "📝 Creating initial project files..."

# Create CURRENT_STATE.md
cat > "$ATLAS_PATH/CURRENT_STATE.md" << EOF
# $PROJECT_NAME - Current State

## Working Directory
\`\`\`
[Add your project working directory path here]
\`\`\`

## Environment Status
- **Status**: New project initialization
- **Local URL**: [Add local development URL]
- **Database**: [Add database info if applicable]

## Current Focus
- Setting up development environment
- Initializing project structure

## Last Updated
$(date '+%Y-%m-%d %H:%M')
EOF

# Create TODOS_ACTIVE.md
cat > "$ATLAS_PATH/TODOS_ACTIVE.md" << EOF
# $PROJECT_NAME - Active TODOs

## Current Session Tasks
- [ ] Complete project environment setup
- [ ] Define project requirements
- [ ] Set up development workflow

## Next Steps
- [ ] [Add your first development tasks here]

## Blocked Items
- None

## Last Updated
$(date '+%Y-%m-%d %H:%M')
EOF

# Create QUICK_RESUME.md
cat > "$ATLAS_PATH/QUICK_RESUME.md" << EOF
# Quick Resume - $PROJECT_NAME

## To Resume This Project:

\`\`\`bash
# From /mnt/c/root directory:
./.claude/.scripts/session.sh $PROJECT_NAME resume
\`\`\`

## Then Read These Files:
1. \`$ROOT_PATH/.claude/atlas/atlas-$PROJECT_NAME/CURRENT_STATE.md\`
2. \`$ROOT_PATH/.claude/atlas/atlas-$PROJECT_NAME/TODOS_ACTIVE.md\`

## Quick Context:
- **What:** [Describe your project]
- **Where:** [Add working directory path]
- **Current Status:** New project setup
- **Last Work:** $(date '+%Y-%m-%d') - Initial project creation

## Key Commands:
\`\`\`bash
# Navigate to project
cd [your-project-working-directory]

# View project
# Browser: [your-local-url]

# Check status
git status
\`\`\`

## Main Files:
- [Add main project files as you develop]
EOF

echo "✅ Initial project files created"

# 5. Initialize Task-Master
echo "🔧 Setting up Task-Master..."
cd "$ATLAS_PATH"

# Check if task-master is installed globally
if ! command -v task-master &> /dev/null; then
    echo "📦 Installing Task-Master globally..."
    npm install -g task-master-ai
fi

# Initialize task-master in project
if command -v task-master &> /dev/null; then
    task-master init
    echo "✅ Task-Master initialized"
else
    echo "⚠️  Task-Master setup failed - you may need to install it manually:"
    echo "   npm install -g task-master-ai"
    echo "   cd $ATLAS_PATH && task-master init"
fi

# 6. Setup WordPress patterns based on parameter
if [[ "$IS_WORDPRESS" == "wordpress" ]] || [[ "$IS_WORDPRESS" == "wp" ]]; then
    echo "📁 Setting up WordPress patterns (specified via parameter)..."
    wp_patterns_source="$ROOT_PATH/.claude/.repos/WordPress-AI-Commander/tools"
    wp_patterns_target="$ATLAS_PATH/scripts/wordpress-patterns"
    
    if [ -d "$wp_patterns_source" ]; then
        mkdir -p "$(dirname "$wp_patterns_target")"
        cp -r "$wp_patterns_source" "$wp_patterns_target"
        echo "✅ WordPress patterns copied"
    else
        echo "⚠️  WordPress patterns not found at: $wp_patterns_source"
        echo "   Run: git clone https://github.com/Idearia/WordPress-AI-Commander.git $ROOT_PATH/.claude/.repos/WordPress-AI-Commander"
    fi
else
    echo "ℹ️  Skipping WordPress patterns (not specified as WordPress project)"
fi

# 7. Verification
echo "🔍 Verifying setup..."
verification=""
[ -f "$ATLAS_PATH/CLAUDE.md" ] && verification+="✅ Atlas brain "
[ -d "$DOCS_PATH/current" ] && verification+="✅ Project docs "
[ -e "$ATLAS_PATH/current" ] && verification+="✅ Junctions "

echo ""
echo "🎉 Project '$PROJECT_NAME' created successfully!"
echo ""
echo "📍 Atlas Brain: $ATLAS_PATH"
echo "📍 Project Docs: $DOCS_PATH"
echo ""
echo "Verification: $verification"
echo ""
echo "Next steps:"
echo "1. Update CURRENT_STATE.md with your project details"
echo "2. Add your working directory path"
echo "3. Start developing!"
echo ""
echo "To resume this project:"
echo "  ./.claude/.scripts/session.sh $PROJECT_NAME resume"