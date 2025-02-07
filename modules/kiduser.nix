
{ config, pkgs, inputs, lib, ... }:

{
  imports = [ 
    ./cinnamon.nix
  ];

  users.users.kid = {
    isNormalUser = true;
    description = "Kid";
    extraGroups = [ "networkmanager" "video" "wheel" ];
    shell = pkgs.zsh;
    # packages = with pkgs; [
    #   firefox
    #   neovim
    #   thunderbird
    # ];
  };

  # Enable automatic login for the user.
  services.displayManager.autoLogin.enable = true;
  services.displayManager.autoLogin.user = "kid";

}
