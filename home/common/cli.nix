{ config, pkgs, inputs, ... }:

{

  imports = [
    ../../modules/zsh.nix
  ];

  xdg = {
    enable = true;

    # neovim
    configFile."nvim-kickstart" = {
      source = "${inputs.nvim-kickstart}";
      recursive = true;
    };
    
    # starship
    configFile."starship.toml".source = ../../conf.d/starship/starship.toml;
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
    eza # A modern replacement for ‘ls’
    fzf # A command-line fuzzy finder
    jq # A lightweight and flexible command-line JSON processor
    lshw
    ripgrep # recursively searches directories for a regex pattern
    yq-go # yaml processer https://github.com/mikefarah/yq

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

    # shell
    hstr
    zsh

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

  ];

  # alacritty - a cross-platform, GPU-accelerated terminal emulator
  programs.alacritty = {
    enable = true;
  };

  programs.hstr.enable = true;

  home.shellAliases = {
      ls = "eza --icons";
      ll ="eza --icons -lhag";
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
  };

  programs.bash = {
    enable = false;
    enableCompletion = true;
    bashrcExtra = ''
      export PATH="$PATH:$HOME/bin:$HOME/.local/bin:$HOME/go/bin"
    '';
  };

  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };

  # starship - an customizable prompt for any shell
  programs.starship = {
    enable = true;
  };

}
