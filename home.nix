{ config, pkgs, inputs, ... }:

{

  home.username = "andrew";
  home.homeDirectory = "/home/andrew";

  # link the configuration file in current directory to the specified location in home directory
  # home.file.".config/i3/wallpaper.jpg".source = ./wallpaper.jpg;

  # link all files in `./scripts` to `~/.config/i3/scripts`
  # home.file.".config/i3/scripts" = {
  #   source = ./scripts;
  #   recursive = true;   # link recursively
  #   executable = true;  # make all files executable
  # };

  # encode the file content in nix configuration file directly
  # home.file.".xxx".text = ''
  #     xxx
  # '';

  # set cursor size and dpi for 4k monitor
  # xresources.properties = {
  #   "Xcursor.size" = 16;
  #   "Xft.dpi" = 172;
  # };


  fonts.fontconfig.enable = true;

  xdg = {
    enable = true;
    
    # alacritty
    configFile."alacritty/alacritty.toml".source = conf.d/alacritty/alacritty.toml;

    # neovim
    configFile."nvim-kickstart" = {
      source = "${inputs.nvim-kickstart}";
      recursive = true;
    };
    
    # starship
    configFile."starship.toml".source = conf.d/starship/starship.toml;

    # sway
    configFile."sway/autostart".source = conf.d/sway/autostart;
    configFile."sway/config".source = conf.d/sway/config;
    configFile."sway/hotkeys".source = conf.d/sway/hotkeys;
    configFile."sway/import-gtk-settings.sh".source = conf.d/sway/import-gtk-settings.sh;
    configFile."sway/swww_random.sh".source = conf.d/sway/swww_random.sh;

    # waybar
    configFile."waybar/config".source = conf.d/waybar/config;
    configFile."waybar/modules.jsonc".source = conf.d/waybar/modules.jsonc;
    configFile."waybar/style.css".source = conf.d/waybar/style.css;

  };

  # Packages that should be installed to the user profile.
  home.packages = with pkgs; [
    # here is some command line tools I use frequently
    # feel free to add your own or remove some of them

    neofetch
    nnn # terminal file manager

    # archives
    zip
    xz
    unzip
    p7zip

    # utils
    ripgrep # recursively searches directories for a regex pattern
    jq # A lightweight and flexible command-line JSON processor
    yq-go # yaml processer https://github.com/mikefarah/yq
    eza # A modern replacement for ‘ls’
    fzf # A command-line fuzzy finder

    # networking tools
    mtr # A network diagnostic tool
    iperf3
    dnsutils  # `dig` + `nslookup`
    ldns # replacement of `dig`, it provide the command `drill`
    aria2 # A lightweight multi-protocol & multi-source command-line download utility
    socat # replacement of openbsd-netcat
    nmap # A utility for network discovery and security auditing
    ipcalc  # it is a calculator for the IPv4/v6 addresses

    # misc
    cowsay
    file
    which
    tree
    gnused
    gnutar
    gawk
    zstd
    gnupg

    zoom-us

    # nix related
    #
    # it provides the command `nom` works just like `nix`
    # with more details log output
    nix-output-monitor

    # productivity
    hugo # static site generator
    glow # markdown previewer in terminal

    btop  # replacement of htop/nmon
    iotop # io monitoring
    iftop # network monitoring

    # system call monitoring
    strace # system call monitoring
    ltrace # library call monitoring
    lsof # list open files

    # system tools
    btop
    killall
    sysstat
    lm_sensors # for `sensors` command
    ethtool
    pciutils # lspci
    usbutils # lsusb

    # nerd fonts
    (pkgs.nerdfonts.override {
      fonts = [ "Hack" "FiraCode" "DroidSansMono" "Mononoki" ];
    })


  ];

  # alacritty - a cross-platform, GPU-accelerated terminal emulator
  programs.alacritty = {
    enable = true;
  };

  programs.bash = {
    enable = true;
    enableCompletion = true;
    # TODO add your cusotm bashrc here
    bashrcExtra = ''
      export PATH="$PATH:$HOME/bin:$HOME/.local/bin:$HOME/go/bin"
    '';

    # set some aliases, feel free to add more or remove some
    shellAliases = {
      ls = "eza --icons";
      ll ="eza --icons -lhag";
      tree = "eza --icons --tree";
      nv="nvim";
      vin="NVIM_APPNAME=nvim-kickstart nvim";
      urldecode = "python3 -c 'import sys, urllib.parse as ul; print(ul.unquote_plus(sys.stdin.read()))'";
      urlencode = "python3 -c 'import sys, urllib.parse as ul; print(ul.quote_plus(sys.stdin.read()))'";
    };
  };

  # basic configuration of git, please change to your own
  programs.git = {
    enable = true;
    userName = "Andrew Wheeler";
    userEmail = "awheeler294@gmail.com";
  };

  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };

  # starship - an customizable prompt for any shell
  programs.starship = {
    enable = true;
  };

  # sway
  wayland.windowManager.sway.systemd.enable = true;

  # waybar
  programs.waybar = {
    # enabled = true;
    systemd.enable = true;
    systemd.target = "sway-session.target";
  };

  # This value determines the home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update home Manager without changing this value. See
  # the home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "24.05";

  # Let home Manager install and manage itself.
  programs.home-manager.enable = true;
}
