{ config, pkgs, lib, ... }:
# let 
#   # currently, there is some friction between sway and gtk:
#   # https://github.com/swaywm/sway/wiki/GTK-3-settings-on-Wayland
#   # the suggested way to set gtk settings is with gsettings
#   # for gsettings to work, we need to tell it where the schemas are
#   # using the XDG_DATA_DIR environment variable
#   # run at the end of sway config
#   configure-gtk = pkgs.writeTextFile {
#     name = "configure-gtk";
#     destination = "/bin/configure-gtk";
#     executable = true;
#     text = let
#       schema = pkgs.gsettings-desktop-schemas;
#       datadir = "${schema}/share/gsettings-schemas/${schema.name}";
#     in ''
#       gnome_schema=org.gnome.desktop.interface
#       gsettings set $gnome_schema gtk-theme 'Matcha-dark-azul'
#     '';
#  };
# in 
{
  programs.niri.enable = true;
  programs.nm-applet.enable = true;

  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  security.polkit.enable = true; # polkit
  services.gnome.gnome-keyring.enable = true; # secret service
  security.pam.services.swaylock = {};

  # xdg-desktop-portal works by exposing a series of D-Bus interfaces
  # known as portals under a well-known name
  # (org.freedesktop.portal.Desktop) and object path
  # (/org/freedesktop/portal/desktop).
  # The portal interfaces include APIs for file access, opening URIs,
  # printing and others.
  services.dbus.enable = true;
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    # gtk portal needed to make gtk apps happy
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  xdg.portal.config.niri = {
    "org.freedesktop.impl.portal.FileChooser" = [ "gtk" ]; # or "kde"
  };

  environment.systemPackages = with pkgs; [ 
    alacritty 
    bemenu # wayland clone of dmenu
    # configure-gtk
    dbus   # make dbus-update-activation-environment available in the path
    dracula-theme # gtk theme
    glib # gsettings
    fuzzel 
    gruvbox-gtk-theme
    kanagawa-gtk-theme
    jasper-gtk-theme
    mako # notification system developed by swaywm maintainer
    matcha-gtk-theme
    mako 
    swayidle 
    swaylock 
    swww
    themechanger
    xfce.thunar
    xfce.thunar-volman
    xfce.thunar-archive-plugin
    xdg-utils # for opening default programs when clicking links
    wl-clipboard # wl-copy and wl-paste for copy/paste from stdin / stdout
    wdisplays # tool to configure displays
    waybar
    wayland
    xwayland-satellite
  ];

  systemd.user.services = {
    
    swww-daemon = {

      unitConfig = {
        Description = "swww daemon";
        PartOf = "graphical-session.target";
        After = "graphical-session.target";
        Requires = "graphical-session.target";
      };
      
      serviceConfig = {
        ExecStart = "${pkgs.swww}/bin/swww-daemon --no-cache";
        Restart = "on-failure";
      };

    };
  };

  systemd.user.targets.graphical-session.wants = [ 
    "swww-daemon.service" 
    "swayidle.service" 
    "waybar.service"
  ];

  users.users.andrew.extraGroups = [ "input" ];
}
