
{ config, pkgs, inputs, lib, ... }:

{
  imports = [ 
    ./cinnamon.nix
  ];

  users.users.kid = {
    isNormalUser = true;
    description = "Kid";
    extraGroups = [ "networkmanager" "video" "wheel" ];
    hashedPassword = "$y$j9T$sV3WeFy3N0697vS.XSvs7.$yOELAs1IRxeB//hxdtxTomyNecqBbBs1JqLUbbx9l2B";
    shell = pkgs.zsh;
    # packages = with pkgs; [
    #   firefox
    #   neovim
    #   thunderbird
    # ];
  };

  # Enable automatic login for the user.
  services.displayManager.autoLogin.enable = lib.mkDefault true;
  services.displayManager.autoLogin.user = lib.mkDefault "kid";

}
