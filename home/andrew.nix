{ config, pkgs, inputs, ... }:

{

  imports = [ 
    ./common/gui.nix
  ];

  home.username = "andrew";
  home.homeDirectory = "/home/andrew";
  home.sessionPath = [
    "$HOME/bin"
  ];

  programs.git = {
    enable = true;
    userName = "Andrew Wheeler";
    userEmail = "awheeler294@gmail.com";
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
