# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:

{
  imports = [ 
  #  ../home/common/cli.nix
  ];


  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    btop
    curl
    dua
    fd
    figlet
    git
    gdu
    ghostty-bin
    helix
    htop
    inetutils
    jq
    ncdu
    neovim
    python3
    sl
    tealdeer
    tldr
    tmux
    unison
    vim
    wget
  ];

  # Set default editor
  environment.variables.EDITOR = "nvim";

  # Disable nix for nix-darwin under Determinate Nix
  nix.enable = false;
  # Perform garbage collection weekly to maintain low disk usage
  # nix.gc = {
  #   automatic = true;
  #   options = "--delete-older-than 1m";
  # };

  # Optimize storage
  # You can also manually optimize the store via:
  #    nix-store --optimise
  # Refer to the following link for more details:
  # https://nixos.org/manual/nix/stable/command-ref/conf-file.html#conf-auto-optimise-store
  # nix.optimise.automatic = true;

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget

  system.primaryUser = "anwheeln";
  # nix.package = pkgs.nix;

  # Necessary for using flakes on this system.
  nix.settings.experimental-features = "nix-command flakes";

  # Create /etc/zshrc that loads the nix-darwin environment.
  programs.zsh.enable = true;  # default shell on catalina
  # programs.fish.enable = true;
  
  security.pam.services.sudo_local.touchIdAuth = true;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;

  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = "aarch64-darwin";

  users.users.anwheeln = {
    name = "anwheeln";
    home = "/Users/anwheeln";
  };
}
