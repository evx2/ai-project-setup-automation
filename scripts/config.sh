#!/bin/bash
# Repository Configuration for AI Project Setup Automation
# This file defines which repositories will be cloned and used

# Repository definitions
# Format: REPO_NAME|REPO_URL|REQUIRED(true/false)|DESCRIPTION
# Change the URLs below to point to your actual repositories

REPOSITORIES=(
    "Software-Engineer-AI-Agent-Atlas|https://github.com/syahiidkamil/Software-Engineer-AI-Agent-Atlas.git|true|Atlas brain template structure"
    "ai-command|https://github.com/mcp-wp/ai-command.git|false|WordPress development patterns and tools"
    "claude-task-master|https://github.com/eyaltoledano/claude-task-master.git|false|Task management integration"
)

# Settings
REPOS_DIRECTORY=".repos"
AUTO_UPDATE_REPOS="false"
CLONE_TIMEOUT="300"
DEFAULT_BRANCH="main"

# WordPress patterns path (relative to ai-command repo)
WORDPRESS_PATTERNS_PATH="includes/tools"

# Function to get repository information
get_repo_info() {
    local repo_key="$1"
    local field="$2"
    
    for repo in "${REPOSITORIES[@]}"; do
        IFS='|' read -r name url required description <<< "$repo"
        if [ "$name" = "$repo_key" ]; then
            case "$field" in
                "name") echo "$name" ;;
                "url") echo "$url" ;;
                "required") echo "$required" ;;
                "description") echo "$description" ;;
            esac
            return 0
        fi
    done
    return 1
}

# Function to list all repositories
list_repositories() {
    echo "📋 Configured repositories:"
    for repo in "${REPOSITORIES[@]}"; do
        IFS='|' read -r name url required description <<< "$repo"
        status="Optional"
        [ "$required" = "true" ] && status="Required"
        echo "  • $name [$status] - $description"
    done
}

# Function to get required repositories
get_required_repos() {
    for repo in "${REPOSITORIES[@]}"; do
        IFS='|' read -r name url required description <<< "$repo"
        if [ "$required" = "true" ]; then
            echo "$name"
        fi
    done
}

# Function to get all repository names
get_all_repo_names() {
    for repo in "${REPOSITORIES[@]}"; do
        IFS='|' read -r name url required description <<< "$repo"
        echo "$name"
    done
}