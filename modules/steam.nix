{ config, pkgs, lib, ... }:
{
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;  # Open ports in the firewall for Steam Remote Play
    gamescopeSession = {
      enable = true;
      args = [ "--fullscreen" ];
    };
  };

  environment.systemPackages = with pkgs; [
    gamemode
    gamescope
    r2modman
    steam
  ];
}
