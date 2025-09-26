{ config, pkgs, inputs, ... }:

{

  imports = [ 
    ./cli.nix
  ];

  # link the configuration file in current directory to the specified location in home directory
  # home.file.".config/i3/wallpaper.jpg".source = ./wallpaper.jpg;

  # link all files in `./scripts` to `~/.config/i3/scripts`
  # home.file.".config/i3/scripts" = {
  #   source = ./scripts;
  #   recursive = true;   # link recursively
  #   executable = true;  # make all files executable
  # };

  # encode the file content in nix configuration file directly
  # home.file.".xxx".text = ''
  #     xxx
  # '';

  # set cursor size and dpi for 4k monitor
  # xresources.properties = {
  #   "Xcursor.size" = 16;
  #   "Xft.dpi" = 172;
  # };

  fonts = {
    fontconfig.enable = true;
  };

  xdg = {
    enable = true;
    
    # alacritty
    configFile."alacritty/alacritty.toml".source = ../../conf.d/alacritty/alacritty.toml;

    # sway
    configFile."sway/autostart".source = ../../conf.d/sway/autostart;
    configFile."sway/config".source = ../../conf.d/sway/config;
    configFile."sway/hotkeys".source = ../../conf.d/sway/hotkeys;
    configFile."sway/import-gtk-settings.sh".source = ../../conf.d/sway/import-gtk-settings.sh;
    configFile."sway/swww_random.sh".source = ../../conf.d/sway/swww_random.sh;

    # waybar
    configFile."waybar/config".source = ../../conf.d/waybar/config;
    configFile."waybar/modules.jsonc".source = ../../conf.d/waybar/modules.jsonc;
    configFile."waybar/style.css".source = ../../conf.d/waybar/style.css;

  };

  # Packages that should be installed to the user profile.
  home = {
    packages = with pkgs; [
      zoom-us
    ];

    preferXdgDirectories = true;

    pointerCursor = {
      enable = true;
      name = "phinger-cursors-dark";
      package = pkgs.phinger-cursors;
      size = 32;
      gtk.enable = true;
      sway.enable = true;
    };
  };

  # alacritty - a cross-platform, GPU-accelerated terminal emulator
  programs.alacritty = {
    enable = true;
  };

  # sway
  wayland.windowManager.sway.systemd.enable = true;

  # waybar
  programs.waybar = {
    # enable = true;
    systemd.enable = true;
    systemd.target = "sway-session.target";
  };
  
}
