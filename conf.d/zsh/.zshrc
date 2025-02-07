local DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
if [[ -e "$HOME"/homebrew ]]; then 
   eval "$($HOME/homebrew/bin/brew shellenv)"
   export HOMEBREW_BUNDLE_FILE=$HOME/.config/Brewfile
fi

# Download Znap, if it's not there yet.
[[ -f "$HOME"/.config/zsh/zsh-snap/znap.zsh ]] ||
    git clone --depth 1 -- \
        https://github.com/marlonrichert/zsh-snap.git .config/zsh/zsh-snap

source "$HOME"/.config/zsh/zsh-snap/znap.zsh  # Start Znap

# `znap source` automatically downloads and starts your plugins.
# znap source 'marlonrichert/zsh-autocomplete'
znap source 'zsh-users/zsh-autosuggestions'
znap source 'zsh-users/zsh-history-substring-search'
znap source 'zsh-users/zsh-syntax-highlighting'

# Print some system information when the shell is first started
# Print a greeting message when shell is started
echo $USER@$HOST  $(uname -srm)

# `znap prompt` makes your prompt visible in just 15-40ms!
# export SPACESHIP_CONFIG_FILE="$HOME/.config/spaceship/spaceship.zsh"
# znap prompt "spaceship-prompt/spaceship-prompt"

## Options section
setopt correct                                                  # Auto correct mistakes
setopt extendedglob                                             # Extended globbing. Allows using regular expressions with *
setopt nocaseglob                                               # Case insensitive globbing
setopt rcexpandparam                                            # Array expension with parameters
setopt nocheckjobs                                              # Don't warn about running processes when exiting
setopt numericglobsort                                          # Sort filenames numerically when it makes sense
setopt nobeep                                                   # No beep
setopt appendhistory                                            # Immediately append history instead of overwriting
setopt histignorealldups                                        # If a new command is a duplicate, remove the older one
setopt autocd                                                   # if only directory path is entered, cd there.

zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'       # Case insensitive tab completion

                                                                # More info on setting LS_COLORS: https://www.bigsoft.co.uk/blog/2008/04/11/configuring-ls_colors
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS} "ow=01;32:di=01;34" # Colored completion (different colors for dirs/files/etc)

zstyle ':completion:*' rehash true                              # automatically find new executables in path 
# Speed up completions
zstyle ':completion:*' accept-exact '*(N)'
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh/cache
#HISTFILE=~/.zhistory
HISTSIZE=1000
SAVEHIST=500
WORDCHARS=${WORDCHARS//\/[&.;]}                                 # Don't consider certain characters part of the word


## Keybindings section
# bindkey -v                                        # vi mode
bindkey '^[[7~' beginning-of-line                 # Home key
bindkey '^[[H' beginning-of-line                  # Home key
if [[ "${terminfo[khome]}" != "" ]]; then
  bindkey "${terminfo[khome]}" beginning-of-line  # [Home] - Go to beginning of line
fi
bindkey '^[[8~' end-of-line                       # End key
bindkey '^[[F' end-of-line                        # End key
if [[ "${terminfo[kend]}" != "" ]]; then
  bindkey "${terminfo[kend]}" end-of-line         # [End] - Go to end of line
fi
bindkey '^[[2~' overwrite-mode                    # Insert key
bindkey '^[[3~' delete-char                       # Delete key
bindkey '^[[C'  forward-char                      # Right key
bindkey '^[[D'  backward-char                     # Left key
bindkey '^[[5~' history-beginning-search-backward # Page up key
bindkey '^[[6~' history-beginning-search-forward  # Page down key

# Navigate words with ctrl+arrow keys
bindkey '^[Oc' forward-word                       #
bindkey '^[Od' backward-word                      #
bindkey '^[[1;5D' backward-word                   #
bindkey '^[[1;5C' forward-word                    #
bindkey '^H' backward-kill-word                   # delete previous word with ctrl+backspace
bindkey '^[[Z' undo                               # Shift+tab undo last action

aliases_file="$HOME/.config/extend-rc/aliases"
if [ -f "$aliases_file" ]; then
   # echo "sourcing aliases from $aliases_file"
   # cat "$aliases_file"

    . "$aliases_file"
else

   echo " --- aliases file $aliases_file not found, using fallback aliases --- "
   ## Alias section 
   alias cp="cp -i"                                  # Confirm before overwriting something
   alias df='df -h'                                  # Human-readable sizes
   alias free='free -m'                              # Show sizes in MB
   alias gitu='git add . && git commit && git push'
   alias ll='ls -lha --color=auto'
   alias slog='sudo tail -f /var/log/syslog'
   #alias tmux="tmux -2"
   #alias tmux="TERM=screen-256color-bce tmux"
   #alias tmux="TERM=xterm-256color tmux"
   #alias tmux="TERM=tmux-256color tmux"
   #alias ssh='TERM=xterm-color ssh'                  # Force xterm-color on ssh sessions
fi

env_file="$HOME/.config/extend-rc/env"
if [ -f "$env_file" ]; then
   # echo "sourcing env from $env_file"
   # cat "$env_file"

    . "$env_file"
fi


# HSTR configuration - add this to ~/.zshrc
alias hh=hstr                             # hh to be alias for hstr
export HISTFILE="$DATA_HOME"/.zsh_history # ensure history file visibility
[[ -e "$HISTFILE" ]] || touch "$HISTFILE"
export HSTR_CONFIG=hicolor                # get more colors

export PATH="$HOME/bin:$HOME/.cargo/bin:$PATH"
NVIM_APPNAME=nvim-kickstart; export NVIM_APPNAME
VISUAL=nvim; export VISUAL EDITOR=nvim; export EDITOR

# Color man pages
export LESS_TERMCAP_mb=$'\E[01;32m'
export LESS_TERMCAP_md=$'\E[01;32m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;47;34m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;36m'
export LESS=-r

# Use autosuggestion
#load_plugin zsh-autosuggestions/zsh-autosuggestions.zsh 
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=8'

if command -v starship >/dev/null 2>&1; then
   export STARSHIP_CACHE="$DATA_HOME"/starship/cache
   eval "$(starship init zsh)"
else
   echo " --- starship command not found, using fallback prompt --- "
   . .config/zsh/prompt.zsh
fi
