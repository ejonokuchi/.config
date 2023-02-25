#!/usr/bin/env zsh
#
# zsh configuration file.
# v5.8
#

# ---
# To profile the loading time of .zshrc, uncomment the following line and the last line:
# zmodload zsh/zprof
# ---

###########
# General #
###########

# Use ANSI color sequences to distinguish file types.
export CLICOLOR=1


###########
# History #
###########

# Use a larger history.
HISTSIZE=1000000
SAVEHIST=1000000

setopt EXTENDED_HISTORY       # Write the history file in the ":start:elapsed;command" format.
setopt SHARE_HISTORY          # Share history between all sessions.
setopt INC_APPEND_HISTORY     # Write to the history file immediately, not when the shell exits.
setopt HIST_IGNORE_DUPS       # Don't record an entry that was just recorded.
setopt HIST_FIND_NO_DUPS      # Ignore repeated lines when searching history.
setopt HIST_REDUCE_BLANKS     # Remove superfluous blanks before recording entry.


##############
# Completion #
##############

setopt AUTO_LIST              # Automatically list choices on ambiguous completion.
setopt AUTO_MENU              # Automatically use menu completion after second tab.
setopt ALWAYS_TO_END          # Move cursor to the end of a completion.
setopt GLOBDOTS               # Dot files can be matched without specifying the dot.

# Load completion listing.
zmodload -i zsh/complist

# Completions: expand aliases and globs, normal completion, fuzzy fall back.
zstyle ':completion:*' completer _expand_alias _extensions _complete _approximate
# Use arrow keys for menu completion.
zstyle ':completion:*' menu select
# Group results by category.
zstyle ':completion:*' group-name ''
# Enable case-insensitive completion.
zstyle ':completion:*' matcher-list '' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}'
# Show descriptions for completions and corrections.
zstyle ':completion:*:*:*:*:descriptions' format '%F{green}-- %d --%f'
zstyle ':completion:*:*:*:*:corrections' format '%F{yellow}!- %d (errors: %e) -!%f'

# Use "new style" zsh completion.
# Below is a minor speed up to limit cache checking to once per day. Saves ~0.05s.
# See: https://gist.github.com/ctechols/ca1035271ad134841284#gistcomment-2308206
autoload -Uz compinit
for dump in ~/.zcompdump(N.mh+24); do
    compinit
done
compinit -C

# # Use "new style" zsh completion.
# autoload -Uz compinit && compinit

# Shift-tab moves backward in menu selection.
bindkey -M menuselect '^[[Z' reverse-menu-complete


##########
# Prompt #
##########

# Enable parameter expansion.
setopt PROMPT_SUBST

# Add Git repository info.
autoload -Uz vcs_info
zstyle ':vcs_info:*' enable git
# Show unstaged changes. Warning: this can be slow for large repositories.
# TODO: use an async prompt.
zstyle ':vcs_info:git:*' formats '%{%F{7}%}(%b%{%f%}%u%{%F{7}%})%{%f%} '
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' unstagedstr '%{%F{1}%}✗%{%f%}'
# # Show branch only, ignoring unstaged changes.
# zstyle ':vcs_info:git:*' formats '%{%F{7}%}(%b)%{%f%} '

# Show information about the current Python virtual environment.
function venv_info() {
    if [[ -n "$VIRTUAL_ENV" ]]; then
        venv_info_msg="%{%F{7}%}(${VIRTUAL_ENV##*/})%{%f%} "
    else
        venv_info_msg=""
    fi
}

# Register the functions.
precmd_functions+=(
  vcs_info
  venv_info
)

# Set prompt style.
#   default:  user:trailing_path/
#    if git:  user:trailing_path/ (branch)
#   if venv:  (venv) user:trailing_path/
export PS1='${venv_info_msg}%F{15}%B%n%b%f:%F{4}%}%1~/%f ${vcs_info_msg_0_}'


##############
# Extensions #
##############

# zmv: Multiple move based on zsh pattern matching.
autoload -Uz zmv

# Enable history substring search.
source /opt/homebrew/share/zsh-history-substring-search/zsh-history-substring-search.zsh
# use the up and down arrows to match history substrings
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down


###########
# Aliases #
###########

# Load aliases.
source $ZDOTDIR/.aliases


#############
# Functions #
#############

# Add functions to the path, if not already loaded.
[[ $fpath == *"${ZDOTDIR}"* ]] || fpath=("${ZDOTDIR}/functions" $fpath)

# Load functions.
autoload -U $ZDOTDIR/functions/*(.:t)


############
# Homebrew #
############

eval $(/opt/homebrew/bin/brew shellenv)


#########
# pyenv #
#########

export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv >/dev/null || export PATH="${PYENV_ROOT}/bin:${PATH}"
eval "$(pyenv init -)"


#######
# nvm #
#######

# nvm: Node version manager
export NVM_DIR="${HOME}/.nvm"

# Lazy load with $ZDOTDIR/functions/nvm. Saves ~0.9s.

# Load nvm into the shell session, as a function.
[ -s "${NVM_DIR}/nvm.sh" ] && source "${NVM_DIR}/nvm.sh"
# Enable nvm bash completion
[ -s "${NVM_DIR}/bash_completion" ] && source "${NVM_DIR}/bash_completion"


#######
# rvm #
#######

# rvm: Ruby version manager
export PATH="${PATH}:${HOME}/.rvm/bin"

# Lazy load with $ZDOTDIR/functions/rvm. Saves ~0.15s.

# Load RVM into the shell session, as a function.
[[ -s "${HOME}/.rvm/scripts/rvm" ]] && source "${HOME}/.rvm/scripts/rvm"

# # Configure OpenSSL version for Ruby, instead of re-installing per version.
# # Note: this may interfere with building old versions of Ruby (e.g <2.4) that use OpenSSL <1.1.
# export RUBY_CONFIGURE_OPTS="--with-openssl-dir=$(brew --prefix openssl@1.1)"

# rvm causes a conflict with git's "HEAD^".
# See: https://github.com/ohmyzsh/ohmyzsh/issues/449
setopt NO_NOMATCH


####################
# Google Cloud SDK #
####################

# Update PATH.
[[ -f '/Users/evan/third-party/google-cloud-sdk/path.zsh.inc' ]] && source '/Users/evan/third-party/google-cloud-sdk/path.zsh.inc'

# Enable command completion.
[[ -f '/Users/evan/third-party/google-cloud-sdk/completion.zsh.inc' ]] && source '/Users/evan/third-party/google-cloud-sdk/completion.zsh.inc'


# ---
# To profile the loading time of .zshrc, uncomment the following line and the first line:
# zprof
# ---
