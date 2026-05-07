{ config, pkgs, inputs, ... }:

{
  imports = [ 
    ./common/gui.nix
  ];

  home.file.".local/bin/niri-tweaks" = {
    source = "${inputs.niri-tweaks}";
    recursive = true;
  };

  systemd.user.services = {

    niri-idle = {
      
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

    niri-tile-to-n = {
      
      Unit = {
        PartOf = "niri.service";
        After = "niri.service";
        Requisite = "niri.service";
      };

      Service = {
        StandardError = "journal";
        StandardOutput = "journal";
        Environment = [ 
          "SYSTEMD_LOG_LEVEL=debug" 
          "HOME=%h" 
          "PATH=/run/current-system/sw/bin/:%h/bin" 
        ];
        ExecStart = "%h/.local/bin/niri-tweaks/niri_tile_to_n.py -m -iw 1 -iw 2 -iw 3 -iw 4";
        Restart = "on-failure";
      };

    };

  }; 
}
