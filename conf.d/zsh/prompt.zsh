# Theming section  
autoload -U compinit colors zcalc
compinit -d
colors

# enable substitution for prompt
setopt prompt_subst

function hostname_if_ssh() {
   if [[ -n $SSH_CONNECTION ]]; then
      #echo "%{$fg[magenta]%}%n%{$reset_color%}@%{$fg[blue]%}%m "
      echo "%{$fg[blue]%}%m "
   fi
}

## Prompt (on left side) similar to default bash prompt, or redhat zsh prompt with colors
# #PROMPT="%(!.%{$fg[red]%}[%n@%m %1~]%{$reset_color%}# .%{$fg[green]%}[%n@%m %1~]%{$reset_color%}$ "

# Print some system information when the shell is first started
# Print a greeting message when shell is started
# echo $USER@$HOST  $(uname -srm)

### Prompt on right side:
##  - shows status of git when in git repository (code adapted from https://techanic.net/2012/12/30/my_git_prompt_for_zsh.html)
##  - shows exit status of previous command (if previous command finished with an error)
##  - is invisible, if neither is the case

# Modify the colors and symbols in these variables as desired.
GIT_PROMPT_SYMBOL="%{$fg[blue]%}±"                              # plus/minus     - clean repo
GIT_PROMPT_PREFIX="%{$fg[green]%}[%{$reset_color%}"
GIT_PROMPT_SUFFIX="%{$fg[green]%}]%{$reset_color%}"
GIT_PROMPT_AHEAD="%{$fg[red]%}ANUM%{$reset_color%}"             # A"NUM"         - ahead by "NUM" commits
GIT_PROMPT_BEHIND="%{$fg[cyan]%}BNUM%{$reset_color%}"           # B"NUM"         - behind by "NUM" commits
GIT_PROMPT_MERGING="%{$fg_bold[magenta]%}⚡︎%{$reset_color%}"     # lightning bolt - merge conflict
GIT_PROMPT_UNTRACKED="%{$fg_bold[red]%}●%{$reset_color%}"       # red circle     - untracked files
GIT_PROMPT_MODIFIED="%{$fg_bold[yellow]%}●%{$reset_color%}"     # yellow circle  - tracked files modified
GIT_PROMPT_STAGED="%{$fg_bold[green]%}●%{$reset_color%}"        # green circle   - staged changes present = ready for "git push"

parse_git_branch() {
  # Show Git branch/tag, or name-rev if on detached head
  ( git symbolic-ref -q HEAD || git name-rev --name-only --no-undefined --always HEAD ) 2> /dev/null
}

parse_git_state() {
  # Show different symbols as appropriate for various Git repository states
  # Compose this value via multiple conditional appends.
  local GIT_STATE=""
  local NUM_AHEAD="$(git log --oneline @{u}.. 2> /dev/null | wc -l | tr -d ' ')"
  if [ "$NUM_AHEAD" -gt 0 ]; then
    GIT_STATE=$GIT_STATE${GIT_PROMPT_AHEAD//NUM/$NUM_AHEAD}
  fi
  local NUM_BEHIND="$(git log --oneline ..@{u} 2> /dev/null | wc -l | tr -d ' ')"
  if [ "$NUM_BEHIND" -gt 0 ]; then
    GIT_STATE=$GIT_STATE${GIT_PROMPT_BEHIND//NUM/$NUM_BEHIND}
  fi
  local GIT_DIR="$(git rev-parse --git-dir 2> /dev/null)"
  if [ -n $GIT_DIR ] && test -r $GIT_DIR/MERGE_HEAD; then
    GIT_STATE=$GIT_STATE$GIT_PROMPT_MERGING
  fi
  if [[ -n $(git ls-files --other --exclude-standard 2> /dev/null) ]]; then
    GIT_STATE=$GIT_STATE$GIT_PROMPT_UNTRACKED
  fi
  if ! git diff --quiet 2> /dev/null; then
    GIT_STATE=$GIT_STATE$GIT_PROMPT_MODIFIED
  fi
  if ! git diff --cached --quiet 2> /dev/null; then
    GIT_STATE=$GIT_STATE$GIT_PROMPT_STAGED
  fi
  if [[ -n $GIT_STATE ]]; then
    echo "$GIT_PROMPT_PREFIX$GIT_STATE$GIT_PROMPT_SUFFIX"
  fi
}

git_prompt_string() {
  local git_where="$(parse_git_branch)"
  
  # If inside a Git repository, print its branch and state
  [ -n "$git_where" ] && echo "$GIT_PROMPT_SYMBOL$(parse_git_state)$GIT_PROMPT_PREFIX%{$fg[yellow]%}${git_where#(refs/heads/|tags/)}$GIT_PROMPT_SUFFIX"
  
  # If not inside the Git repo, print exit codes of last command (only if it failed)
  [ ! -n "$git_where" ] && echo "%{$fg[red]%} %(?..[%?])"
}

# Right prompt with exit status of previous command if not successful
 #RPROMPT="%{$fg[red]%} %(?..[%?])" 
# Right prompt with exit status of previous command marked with ✓ or ✗
 #RPROMPT="%(?.%{$fg[green]%}✓ %{$reset_color%}.%{$fg[red]%}✗ %{$reset_color%})"

# Show vi mode in prompt
function zle-line-init zle-keymap-select {
   VIM_PROMPT="%{$bg[blue]%}%{$fg[black]%} Normal %{$reset_color%} "
   # RPS1="${${KEYMAP/vicmd/$VIM_PROMPT}/(main|viins)/}$(git_prompt_string) $EPS1"
   RPS1="${${KEYMAP/vicmd/$VIM_PROMPT}/(main|viins)/} $EPS1"
   zle reset-prompt
}

zle -N zle-line-init
zle -N zle-keymap-select

# Maia prompt
PROMPT="$(hostname_if_ssh)%B%{$fg[cyan]%}%(4~|%-1~/.../%2~|%~)%u%b >%{$fg[green]%}>%B%(?.%{$fg[green]%}.%{$fg[red]%})>%{$reset_color%}%b " 
RPROMPT='$(git_prompt_string)'
