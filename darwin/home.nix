{ config, pkgs, inputs, ... }:

{

  imports = [
    ../home/nvim.nix
    ../home/zsh.nix
    # ./paneru.nix
  ];

  xdg = {
    enable = true;
    
    # starship
    configFile."starship.toml".source = ../conf.d/starship/starship.toml;
  };

  home.homeDirectory = "/Users/anwheeln";

  # Packages that should be installed to the user profile.
  home.packages = with pkgs; [
    # here is some command line tools I use frequently
    # feel free to add your own or remove some of them
    bat
    # helix
    # micro-full
    # neofetch
    nnn # terminal file manager

    # archives
    # zip
    # xz
    # unzip
    # p7zip

    # utils
    # caligula # cli disk image writer, like etcher 
    eza # A modern replacement for ‘ls’
    fzf # A command-line fuzzy finder
    jq # A lightweight and flexible command-line JSON processor
    # lshw
    ripgrep # recursively searches directories for a regex pattern
    yq-go # yaml processer https://github.com/mikefarah/yq

    # networking tools
    # mtr # A network diagnostic tool
    # iperf3
    # dnsutils  # `dig` + `nslookup`
    # ldns # replacement of `dig`, it provide the command `drill`
    # aria2 # A lightweight multi-protocol & multi-source command-line download utility
    # socat # replacement of openbsd-netcat
    # nmap # A utility for network discovery and security auditing
    # ipcalc  # it is a calculator for the IPv4/v6 addresses

    # misc
    cowsay
    # file
    # which
    tree
    tealdeer
    # gnused
    # gnutar
    # gawk
    # zstd
    # gnupg

    # nix related
    #
    # it provides the command `nom` works just like `nix`
    # with more details log output
    # nix-output-monitor

    # productivity
    # hugo # static site generator
    # glow # markdown previewer in terminal

    # btop  # replacement of htop/nmon
    # iotop # io monitoring
    # iftop # network monitoring

    # shell
    hstr
    zsh

    # system call monitoring
    # strace # system call monitoring
    # ltrace # library call monitoring
    # lsof # list open files

    # system tools
    # btop
    # killall
    # sysstat
    # lm_sensors # for `sensors` command
    # ethtool
    # pciutils # lspci
    # usbutils # lsusb

    skhd
  ];

  # alacritty - a cross-platform, GPU-accelerated terminal emulator
  # programs.alacritty = {
  #   enable = true;
  # };

  programs.bash = {
    enable = false;
    enableCompletion = true;
    bashrcExtra = ''
      export PATH="$PATH:$HOME/bin:$HOME/.local/bin:$HOME/go/bin"
    '';
  };

  programs.ghostty = {
    enable = true;
    package = pkgs.ghostty-bin;
    enableZshIntegration = true;
    settings = {
      cursor-color = "cell-foreground";
      cursor-style = "block";
      cursor-style-blink = "false";
      font-feature = "-calt";
      font-size = 18;
      #theme = "Desert";
      theme = "Ayu Mirage";
      shell-integration-features = "no-cursor, ssh-terminfo, ssh-env";
    };
  };

  programs.hstr.enable = true;

  programs.helix = {
    enable = true;
    settings = {
      theme = "autumn_night_transparent";
      editor.cursor-shape = {
        normal = "block";
        insert = "bar";
        select = "underline";
      };
    };
    languages.language = [{
      name = "nix";
      auto-format = true;
      formatter.command = "${pkgs.nixfmt}/bin/nixfmt";
    }];
    themes = {
      autumn_night_transparent = {
        "inherits" = "autumn_night";
        "ui.background" = { };
      };
    };
  };

  # starship - an customizable prompt for any shell
  programs.starship = {
    enable = true;
  };

  programs.tealdeer = {
    enable = true;
    enableAutoUpdates = true;
  };

  programs.zsh = {
    envExtra = "source \"$HOME/.cargo/env\"";
    initContent = "source \"$HOME/.zshrc\"";
  };

  services.skhd = {
    enable = true;
    config = ''
      cmd - return : open -na Ghostty.app --args --quit-after-last-window-closed=true --working-directory=home
    '';
  };

  home.shellAliases = {
    ls = "eza --icons";
    ll ="eza --icons -lhaag";
    tree = "eza --icons --tree";

    cp = "cp -i";       # Confirm before overwriting something            
    df = "df -h";       # Human-readable sizes
    free = "free -m";   # Show sizes in MB
    grep = "grep -i";   # Case insensitive

    ssh = "TERM=xterm-256color ssh";

    vin = "NVIM_APPNAME=nvim-kickstart nvim";
    hh = "hstr";

    urldecode = "python3 -c 'import sys, urllib.parse as ul; print(ul.unquote_plus(sys.stdin.read()))'";
    urlencode = "python3 -c 'import sys, urllib.parse as ul; print(ul.quote_plus(sys.stdin.read()))'";

    nixup = "sudo nix run nix-darwin -- switch --flake ~/.config/nix/darwin --impure";
    homeup = "sudo darwin-rebuild switch --flake ~/.config/nix/darwin --impure";
  };

  # Home Manager needs a bit of information about you and the paths it should
  # manage.

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "25.11"; # Please read the comment before changing. 
}
