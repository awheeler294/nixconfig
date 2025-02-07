{ config, pkgs, inputs, lib, ... }:

{
  services.xserver = {
    enable = true;
    
    # Configure keymap in X11
    xkb = {
      layout = "us";
      variant = "";
    };

    desktopManager.cinnamon = {
      enable = true;
    };
  };

  services = {
    libinput.enable = true;
    displayManager.sddm = {
      enable = true;
      package = pkgs.kdePackages.sddm;
      theme = "sddm-astronaut-theme";
      extraPackages = with pkgs; [
        pkgs.qt6.qt5compat
      ];
    };
    displayManager.defaultSession = "cinnamon";
  };

  environment.systemPackages = with pkgs; [
    sddm-astronaut
  ];
}
