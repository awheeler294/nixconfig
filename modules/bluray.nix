{ config, pkgs, ... }:

{
  
  boot.kernelModules = [ "sg" ];
  
  environment.systemPackages = let
    libbluray = pkgs.libbluray.override {
      withAACS = true;
      withBDplus = true;
    };
    myVlc = pkgs.vlc.override { inherit libbluray; }; # renamed this to avoid potential shadowing by `with pkgs;` 
  in [
    myVlc
  ];

  users.users.andrew = {
    extraGroups = [ "cdrom" ];
  };
}
