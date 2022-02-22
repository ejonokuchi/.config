#!/usr/bin/env bash
#
# Install the full configuration.
#

# Path to the downloaded config directory. Defaults to the current working directory.
CONFIG_DIR=${1:-$(pwd)}


####################
# Helper functions #
####################

# Import printing helpers.
. ./scripts/print || {
    printf "\n\e[31mError: unable to load helper script!\e[0m\n\n"
    echo "Please run this command directly from the config directory with:"
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

    [[ -e "${dst}" || -L "${dst}" ]] && backup "${dst}"
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
if [[ ! -e "${HOME}/.config" ]]; then
    print_warn "No ~/.config directory detected, creating..."
    mkdir "${HOME}/.config"
fi

# iTerm
print_info "Note: iTerm preferences must be configured manually. See: ${CONFIG_DIR}/iterm/README.md"

# scripts
print_info "Linking scripts to: ${HOME}/.config/scripts"
with_backup "ln -s" "${CONFIG_DIR}/scripts" "${HOME}/.config/scripts"

# tmux
print_info "Linking tmux configuration to: ${HOME}/.tmux.conf"
with_backup "ln -s" "${CONFIG_DIR}/tmux/.tmux.conf" "${HOME}/.tmux.conf"

# VS Code
print_info "Linking VS Code preferences to: ${HOME}/Library/Application Support/Code/User"
with_backup "ln -s" "${CONFIG_DIR}/vscode/keybindings.json" "${HOME}/Library/Application Support/Code/User/keybindings.json"
with_backup "ln -s" "${CONFIG_DIR}/vscode/settings.json" "${HOME}/Library/Application Support/Code/User/settings.json"

# Warp
[[ -e "${HOME}/.warp/themes" ]] || mkdir -p "${HOME}/.warp/themes"
# Symlinked themes aren't detected by Warp, so a hard copy is necessary.
print_info "Copying Warp theme to: ${HOME}/.warp/themes/"
with_backup "cp -r" "${CONFIG_DIR}/warp/themes/emj.yaml" "${HOME}/.warp/themes/emj.yaml"

# zsh
[[ -e "${HOME}/.config/zsh" ]] || mkdir -p "${HOME}/.config/zsh"

print_info "Linking zsh functions to: ${HOME}/.config/zsh/functions"
with_backup "ln -s" "${CONFIG_DIR}/zsh/functions" "${HOME}/.config/zsh/functions"

print_info "Linking zsh dotfiles to: ${HOME}/.config/zsh"
with_backup "ln -s" "${CONFIG_DIR}/zsh/.aliases" "${HOME}/.config/zsh/.aliases"
with_backup "ln -s" "${CONFIG_DIR}/zsh/.zlogin" "${HOME}/.config/zsh/.zlogin"
with_backup "ln -s" "${CONFIG_DIR}/zsh/.zlogout" "${HOME}/.config/zsh/.zlogout"
with_backup "ln -s" "${CONFIG_DIR}/zsh/.zprofile" "${HOME}/.config/zsh/.zprofile"
with_backup "ln -s" "${CONFIG_DIR}/zsh/.zshrc" "${HOME}/.config/zsh/.zshrc"

print_info "Linking zsh environment file to: ${HOME}/.zshenv"
with_backup "ln -s" "${CONFIG_DIR}/zsh/.zshenv" "${HOME}/.zshenv"


print_info "\nDone!\n"
