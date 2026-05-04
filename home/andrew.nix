{ config, pkgs, inputs, ... }:

{

  home.username = "andrew";
  home.homeDirectory = "/home/andrew";
  home.sessionPath = [
    "$HOME/bin"
  ];

  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "Andrew Wheeler";
        email = "awheeler294@gmail.com";
      };
      init.defaultBranch = "main";
    };
  };

  programs.ssh = {
      enable = true;
      matchBlocks = {
         "proxy-server" = {
            hostname = "45.32.229.198";
            user = "andrew";
         };
         "vaulty-server" = {
            hostname = "192.168.0.5";
            user = "andrew";
         };
         "forgejo.home.arpa" = {
            hostname = "forgejo.home.arpa";
            user = "git";
            port = 22;
         };
      };
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
