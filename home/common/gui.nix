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

    # fuzzel
    configFile."fuzzel/fuzzel.ini".source = ../../conf.d/fuzzel/fuzzel.ini;

    # mako
    configFile."mako/config".source = ../../conf.d/mako/config;

    # niri
    configFile."niri/config.kdl".source = ../../conf.d/niri/config.kdl;

    # sway
    configFile."sway/autostart".source = ../../conf.d/sway/autostart;
    configFile."sway/config".source = ../../conf.d/sway/config;
    configFile."sway/hotkeys".source = ../../conf.d/sway/hotkeys;
    configFile."sway/import-gtk-settings.sh".source = ../../conf.d/sway/import-gtk-settings.sh;
    configFile."sway/swww_random.sh".source = ../../conf.d/sway/swww_random.sh;

    # swaylock
    configFile."swaylock/config".source = ../../conf.d/swaylock/config;
    configFile."swaylock/config-fx".source = ../../conf.d/swaylock/config-fx;

    # waybar
    configFile."waybar/config.jsonc".source = ../../conf.d/waybar/config.jsonc;
    configFile."waybar/modules.jsonc".source = ../../conf.d/waybar/modules.jsonc;
    configFile."waybar/style.css".source = ../../conf.d/waybar/style.css;

    # unison
    configFile."unison/wallpaper.prf".source = ../../conf.d/unison/wallpaper.prf;

  };

  systemd.user.services = {
    
    swww-random = {
    
      Unit = {
        Description = "Set a random wallpaper using swww";
        Wants = "swww-daemon.service";
        After = "swww-daemon.service";
        Requisite = "swww-daemon.service";
      };
      
      Service = {
        StandardError = "journal";
        StandardOutput = "journal";
        Environment = [ 
          "SYSTEMD_LOG_LEVEL=debug" 
          "HOME=%h" 
          "PATH=/run/current-system/sw/bin/:%h/bin" 
        ];
        ExecSearchPath = [ "%h/bin/" ];
        ExecStart = "${pkgs.python3}/bin/python3 %h/bin/swww-random";
        Restart = "on-failure";
      };
    
      Install = {
        WantedBy = [ "default.target" ];
      };

    };

    swayidle = {
      
      Unit = {
        PartOf = "graphical-session.target";
        After = "graphical-session.target";
        Requisite = "graphical-session.target";
      };

      Service = {
        StandardError = "journal";
        StandardOutput = "journal";
        Environment = [ 
          "SYSTEMD_LOG_LEVEL=debug" 
          "HOME=%h" 
          "PATH=/run/current-system/sw/bin/:%h/bin" 
        ];
        ExecSearchPath = [ "%h/bin/" ];
        ExecStart = "${pkgs.swayidle}/bin/swayidle -w timeout 300 '%h/bin/swaylock-swww -f 30 -g 31' timeout 390 'niri msg action power-off-monitors' timeout 600 'systemctl suspend' before-sleep '%h/bin/swaylock-swww -f 0 -g 0'";
        Restart = "on-failure";
      };

    };

    waybar = {

      Unit = {
        Description = "Highly customizable Wayland bar for Sway and Wlroots based compositors";
        Documentation = "https://github.com/Alexays/Waybar/wiki/";
        PartOf = "graphical-session.target";
        After = "graphical-session.target";
        Requisite = "graphical-session.target";
      };

      Service = {
        Environment = [ 
          "PATH=/run/current-system/sw/bin/:${pkgs.fuzzel}/bin/:${pkgs.procps}/bin/:${pkgs.psmisc}/bin/" 
        ];
        ExecStart = "${pkgs.waybar}/bin/waybar";
        ExecReload = "kill -SIGUSR2 $MAINPID";
        Restart = "on-failure";
      };

      Install = {
        WantedBy = [ "graphical-session.target" ];
      };

    };

  };

  gtk = {
    enable = true;
    
    theme = {
      name = "Matcha-dark-azul";
      package = pkgs.matcha-gtk-theme;
    };
    
    iconTheme = {
      name = "Qogir-Dark";
    };
  };

  home = {
    file."bin" = {
      source = ../../conf.d/scripts;
      recursive = true;
    };

    # Packages that should be installed to the user profile.
    packages = with pkgs; [
      bc
      discord
      kanagawa-gtk-theme
      kanagawa-icon-theme
      libnotify
      matcha-gtk-theme
      networkmanagerapplet
      nordzy-icon-theme
      papirus-icon-theme
      qogir-icon-theme
      swayidle
      swaylock-effects
      swww
      vimix-icon-theme
      wineWow64Packages.waylandFull
      wireplumber
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

    sessionVariables = {
      UNISON = "${config.xdg.configHome}/unison";
    };

  };

  # alacritty - a cross-platform, GPU-accelerated terminal emulator
  programs.alacritty = {
    enable = true;
  };

  # mako
  services.mako.enable = true;

  # network manager applet
  services.network-manager-applet.enable = true;

  # sway
  wayland.windowManager.sway.systemd.enable = true;

  # waybar
  programs.waybar = {
    enable = false;
    systemd.enable = false;
    # systemd.target = "sway-session.target";
  };

  services.swww.enable = true;
  
}
