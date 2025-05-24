{ config, pkgs, inputs, lib, ... }:

{
  services = {
    xserver = {
      enable = true;
      
      # Configure keymap in X11
      xkb = {
        layout = "us";
        variant = "";
      };

      desktopManager.cinnamon = {
        enable = true;
      };

      displayManager.xserverArgs = [ "-logfile /var/log/sddm-xorg" ];
      displayManager.setupCommands = ''
        echo "Hello World!"
        # Get the list of connected outputs
        outputs=$(xrandr | grep " connected" | awk '{print $1}')

        # Loop through each output
        for output in $outputs; do
          # Get the preferred mode for the output
          preferred_mode=$(xrandr | grep "$output connected" -A 50 | grep "*" | grep "+" | awk '{print $1}')

          # If a preferred mode is found, set the output to that mode
          if [ -n "$preferred_mode" ]; then
            echo "Set $output to $preferred_mode"
          else
            if [-n "$(xrandr | grep "$output connected" -A 10 | grep "3340x1440" | awk '{print $1}')"]; then
              preferred_mode="3440x1440"
            else
              preferred_mode="$(xrandr | grep "$output connected" -A 1 | awk '{print $1}')"
            fi
            echo "Could not find preferred mode for $output, defaulting to $preferred_mode"
          fi

          xrandr --output "$output" --mode "$preferred_mode"
        done
      '';
    };

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
