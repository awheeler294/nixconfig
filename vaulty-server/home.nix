{ config, pkgs, inputs, ... }:

{
  home-manager.users = {

    andrew = {
      imports = [
        ../home/andrew.nix
        ../home/common/gui.nix
        ../home/nvim.nix
        ../home/zsh.nix
      ];

      programs.fish.enable = true;

    };

  };
}
