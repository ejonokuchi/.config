#!/usr/bin/env bash
#
# Install the full configuration.
#

# Path to the downloaded config directory. Defaults to ~/.config.
CONFIG_DIR=${1:-"${HOME}/.config"}


####################
# Helper functions #
####################

# Import printing helpers.
. ./scripts/print || {
    printf "\n\e[31mError: unable to load helper script!\e[0m\n\n"
    echo "Please run this command directly from the .config directory with:"
    echo "   ./install.sh"
    echo ""
    echo "Currently in: $(pwd)"
    exit 1
}

# Move `target_path` to `target_path.timestamp.backup`.
function backup() {
    local target_path=$1

    backup_path="${target_path%/}.${call_timestamp}.backup"
    print_warn "Moving existing file to a backup: ${backup_path}"
    mv "${target_path}" "${backup_path}"
}

# Execute a command of the form `cmd src dst`, with backups for existing `dst`.
function with_backup() {
    local cmd=$1
    local src=$2
    local dst=$3

    [[ -e "${dst}" ]] && backup "${dst}"
    $cmd "${src}" "${dst}"
}


###############
# Main script #
###############

print_info "Using config directory: ${CONFIG_DIR}"
call_timestamp=$(date +%s)

# Install system packages

print_header "Installing dependencies..."

brew_packages_to_install=(
    # referenced
    tmux
    tree
    zsh-history-substring-search
    # recommended
    ffmpeg
    htop
    jq
    ngrok/ngrok/ngrok
    tldr
)

print_info "Will try to install the following homebrew packages:"
for pkg in "${brew_packages_to_install[@]}"; do
    print_info "    ${pkg}"
done
echo ""

read -rp "Would you like to continue? (y)es, (s)kip, (n)o: "
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    brew install "${brew_packages_to_install[@]}"
elif [[ $REPLY =~ ^[Ss]$ ]]; then
    print_info "Skipping dependencies..."
else
    print_info "Aborting..."
    exit 1
fi

# Link configurations

print_header "Linking configurations..."

# Use direct file paths instead of globs, to avoid unexpected behavior.

# iTerm
print_info "Note: iTerm preferences must be configured manually. See: ${CONFIG_DIR}/iterm/README.md"

# scripts
print_info "Copying scripts"
with_backup "cp" "${CONFIG_DIR}/scripts/print" "${HOME}/.config/scripts/print"

# tmux
print_info "Symlinking tmux configuration"
with_backup "ln -s" "${CONFIG_DIR}/tmux/.tmux.conf" "${HOME}/.tmux.conf"

# VS Code
print_info "Symlinking VS Code preferences"
with_backup "ln -s" "${CONFIG_DIR}/vscode/keybindings.json" "${HOME}/Library/Application Support/Code/User/keybindings.json"
with_backup "ln -s" "${CONFIG_DIR}/vscode/settings.json" "${HOME}/Library/Application Support/Code/User/settings.json"

# Warp
print_info "Copying Warp theme"
# Links aren't detected by Warp, so a copy is necessary.
with_backup "cp -r" "${CONFIG_DIR}/warp/themes/emj.yaml" "${HOME}/.warp/themes/emj.yaml"

# zsh
# Make copies for zsh, as the XDG_CONFIG variables are defined by .zshenv.
print_info "Copying zsh functions"
with_backup "cp -r" "${CONFIG_DIR}/zsh/functions" "${HOME}/.config/zsh/functions"
print_info "Copying zsh dotfiles"
with_backup "cp" "${CONFIG_DIR}/zsh/.aliases" "${HOME}/.config/zsh/.aliases"
with_backup "cp" "${CONFIG_DIR}/zsh/.zlogin" "${HOME}/.config/zsh/.zlogin"
with_backup "cp" "${CONFIG_DIR}/zsh/.zlogout" "${HOME}/.config/zsh/.zlogout"
with_backup "cp" "${CONFIG_DIR}/zsh/.zprofile" "${HOME}/.config/zsh/.zprofile"
with_backup "cp" "${CONFIG_DIR}/zsh/.zshenv" "${HOME}/.config/zsh/.zshenv"
with_backup "cp" "${CONFIG_DIR}/zsh/.zshrc" "${HOME}/.config/zsh/.zshrc"
print_info "Symlinking .zshenv"
# Also create the required link for .zshenv, which must live in the home directory.
with_backup "ln -s" "${HOME}/.config/zsh/.zshenv" "${HOME}/.zshenv"


print_info "\nDone!\n"
