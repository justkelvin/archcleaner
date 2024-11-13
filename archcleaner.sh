#!/bin/bash

# ArchCleaner - Advanced System Cleanup Utility for Arch Linux
# This script provides comprehensive system cleaning functionality including:
# - Pacman cache management
# - Unused dependency removal
# - Old configuration cleanup
# - System journal optimization
# - Package cache cleanup with version retention
# - Broken symlink detection and cleanup

set -e  # Exit on error

# Color definitions for better output readability
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Required packages check
REQUIRED_PACKAGES=(paccache pacman-contrib fd)

# Configuration
CACHE_VERSIONS_TO_KEEP=2
JOURNAL_SIZE="500M"
OLD_CONFIG_DIRS=(
    "$HOME/.config"
    "$HOME/.cache"
    "$HOME/.local/share"
)

# Function to check if script is run as root
check_root() {
    if [ "$EUID" -ne 0 ]; then
        echo -e "${RED}Please run as root${NC}"
        exit 1
    fi
}

# Function to check for required packages
check_dependencies() {
    local missing_deps=()
    for package in "${REQUIRED_PACKAGES[@]}"; do
        if ! pacman -Qi "$package" >/dev/null 2>&1; then
            missing_deps+=("$package")
        fi
    done
    
    if [ ${#missing_deps[@]} -ne 0 ]; then
        echo -e "${YELLOW}Missing required packages: ${missing_deps[*]}${NC}"
        read -rp "Would you like to install them now? [y/N] " response
        if [[ "$response" =~ ^[Yy]$ ]]; then
            pacman -S "${missing_deps[@]}"
        else
            echo -e "${RED}Cannot proceed without required packages.${NC}"
            exit 1
        fi
    fi
}

# Function to clean pacman cache while keeping recent versions
clean_pacman_cache() {
    echo -e "\n${BLUE}=== Cleaning Pacman Cache ===${NC}"
    
    # Get initial cache size
    initial_size=$(du -sh /var/cache/pacman/pkg | cut -f1)
    
    # Remove all versions of uninstalled packages
    echo "Removing all cached versions of uninstalled packages..."
    paccache -ruk0
    
    # Keep only specified number of versions for installed packages
    echo "Keeping only $CACHE_VERSIONS_TO_KEEP most recent versions of installed packages..."
    paccache -rk"$CACHE_VERSIONS_TO_KEEP"
    
    # Get final cache size
    final_size=$(du -sh /var/cache/pacman/pkg | cut -f1)
    
    echo -e "${GREEN}Cache cleanup complete!${NC}"
    echo "Initial size: $initial_size"
    echo "Final size: $final_size"
}

# Function to remove unused dependencies
clean_unused_deps() {
    echo -e "\n${BLUE}=== Removing Unused Dependencies ===${NC}"
    
    # Find unused packages
    unused_pkgs=$(pacman -Qtdq)
    
    if [ -n "$unused_pkgs" ]; then
        echo "Found unused packages. Removing..."
        pacman -Rns $(pacman -Qtdq) --noconfirm
        echo -e "${GREEN}Removed unused packages successfully!${NC}"
    else
        echo -e "${GREEN}No unused dependencies found.${NC}"
    fi
}

# Function to clean old config files
clean_old_configs() {
    echo -e "\n${BLUE}=== Cleaning Old Configuration Files ===${NC}"
    
    local removed_count=0
    
    for dir in "${OLD_CONFIG_DIRS[@]}"; do
        if [ -d "$dir" ]; then
            echo "Scanning $dir for obsolete configurations..."
            
            # Find and remove broken symlinks
            find "$dir" -xtype l -print -delete 2>/dev/null | while read -r file; do
                echo "Removed broken symlink: $file"
                ((removed_count++))
            done
            
            # Find and prompt for .old, .bak, and similar files
            while IFS= read -r file; do
                if [ -f "$file" ]; then
                    echo "Found potential obsolete file: $file"
                    read -rp "Remove this file? [y/N] " response
                    if [[ "$response" =~ ^[Yy]$ ]]; then
                        rm -f "$file"
                        ((removed_count++))
                        echo "Removed: $file"
                    fi
                fi
            done < <(find "$dir" \( -name "*.old" -o -name "*.bak" -o -name "*.orig" \) -type f 2>/dev/null)
        fi
    done
    
    echo -e "${GREEN}Removed $removed_count obsolete configuration files and broken symlinks.${NC}"
}

# Function to clean and optimize systemd journals
clean_journals() {
    echo -e "\n${BLUE}=== Optimizing System Journals ===${NC}"
    
    # Vacuum journals to size limit
    journalctl --vacuum-size="$JOURNAL_SIZE"
    
    # Rotate and remove old journals
    journalctl --rotate
    journalctl --vacuum-time=7d
    
    echo -e "${GREEN}Journal cleanup complete!${NC}"
}

# Function to display system cleaning summary
display_summary() {
    echo -e "\n${BLUE}=== System Cleanup Summary ===${NC}"
    echo "- Pacman cache cleaned and optimized"
    echo "- Unused dependencies removed"
    echo "- Old configuration files cleaned"
    echo "- System journals optimized"
    
    # Display current system stats
    echo -e "\n${BLUE}Current System Status:${NC}"
    df -h / | tail -n 1
    free -h | grep 'Mem:' | awk '{print "Memory: " $3 "/" $2}'
}

# Main execution
main() {
    echo -e "${BLUE}=== ArchCleaner - Advanced System Cleanup Utility ===${NC}"
    
    check_root
    check_dependencies
    
    # Prompt for each cleaning operation
    read -rp "Clean pacman cache? [y/N] " response
    [[ "$response" =~ ^[Yy]$ ]] && clean_pacman_cache
    
    read -rp "Remove unused dependencies? [y/N] " response
    [[ "$response" =~ ^[Yy]$ ]] && clean_unused_deps
    
    read -rp "Clean old config files? [y/N] " response
    [[ "$response" =~ ^[Yy]$ ]] && clean_old_configs
    
    read -rp "Optimize system journals? [y/N] " response
    [[ "$response" =~ ^[Yy]$ ]] && clean_journals
    
    display_summary
}

# Execute main function
main
