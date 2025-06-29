{ config, pkgs, inputs, lib, ... }: {
  imports = [
    ./hardware-configuration.nix
    
    ../modules/common-base.nix
    
  ];

  boot.tmp.cleanOnBoot = true;
  zramSwap.enable = false;
  #networking.hostName = "racknerd-1cdca1d";
  networking.hostName = "proxy-server-racknerd-1cdca1d";
  networking.domain = "";
  services.openssh.enable = true;

  time.timeZone = lib.mkForce "America/Seattle";

  system.stateVersion = "23.11";
}
