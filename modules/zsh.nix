{ config, pkgs, inputs, lib, ... }:

{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    dotDir = ".config/zsh";
    history.append = true;
    history.save = 10000;
    history.size = 10000;
    history.ignoreDups = true;
    
    historySubstringSearch = {
      enable = true;
      searchDownKey = [
        "$terminfo[kcud1]"
        "^[[B"
      ];
      searchUpKey = [
        "$terminfo[kcuu1]"
        "^[[A"
      ];
    };
    
    autosuggestion = {
      enable = true;
      strategy = [
        "match_prev_cmd"
        "completion"
        "history"
      ];
    };
    
    syntaxHighlighting.enable = true;

    initExtra = ''
      # Print some system information when the shell is first started
      # Print a greeting message when shell is started
      echo $USER@$HOST  $(uname -srm)

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
      setopt prompt_subst                                             # enable substitution for prompt

      zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'       # Case insensitive tab completion

                                                                      # More info on setting LS_COLORS: https://www.bigsoft.co.uk/blog/2008/04/11/configuring-ls_colors
      zstyle ':completion:*:default' list-colors ''${(s.:.)LS_COLORS} "ow=01;32:di=01;34" # Colored completion (different colors for dirs/files/etc)

      zstyle ':completion:*' rehash true                              # automatically find new executables in path 
      # Speed up completions
      zstyle ':completion:*' accept-exact '*(N)'
      zstyle ':completion:*' use-cache on
      zstyle ':completion:*' cache-path ~/.cache/zsh
      
      ## Theming section  
      autoload -U compinit colors zcalc
      compinit -d
      colors
      
      ## Keybindings section
      bindkey '^[[7~' beginning-of-line                   # Home key
      bindkey '^[[H' beginning-of-line                    # Home key
      if [[ "''${terminfo[khome]}" != "" ]]; then
        bindkey "''${terminfo[khome]}" beginning-of-line  # [Home] - Go to beginning of line
      fi
      bindkey '^[[8~' end-of-line                         # End key
      bindkey '^[[F' end-of-line                          # End key
      if [[ "''${terminfo[kend]}" != "" ]]; then
        bindkey "''${terminfo[kend]}" end-of-line         # [End] - Go to end of line
      fi
      bindkey '^[[2~' overwrite-mode                      # Insert key
      bindkey '^[[3~' delete-char                         # Delete key
      bindkey '^[[C'  forward-char                        # Right key
      bindkey '^[[D'  backward-char                       # Left key
      bindkey '^[[5~' history-beginning-search-backward   # Page up key
      bindkey '^[[6~' history-beginning-search-forward    # Page down key

      # Navigate words with ctrl+arrow keys
      bindkey '^[Oc' forward-word                         #
      bindkey '^[Od' backward-word                        #
      bindkey '^[[1;5D' backward-word                     #
      bindkey '^[[1;5C' forward-word                      #
      bindkey '^H' backward-kill-word                     # delete previous word with ctrl+backspace
      bindkey '^[[Z' undo                                 # Shift+tab undo last action

      steam-id() {
         grep -n "name" ~/.steam/steam/steamapps/*.acf | sed -e 's/^.*_//;s/\.acf:.:/ /;s/name//;s/"//g;s/\t//g;s/ /-/' | awk -F"-" '{printf "%-40s %s\n", $2, $1}' | sort
      }
    '';
  };
}
