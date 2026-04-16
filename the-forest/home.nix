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

      home.shellAliases = {
        makemkv = "NIXPKGS_ALLOW_UNFREE=1 nix-shell --run makemkv -p makemkv -I nixpkgs=https://github.com/NixOS/nixpkgs/archive/2c36ece932b8c0040893990da00034e46c33e3e7.tar.gz";
      };
    };

    kid = import ../home/kid.nix;

  };
}
