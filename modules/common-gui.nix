
{ config, pkgs, inputs, lib, ... }:

{

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    cacert
    firefox
    # luanti
    minutor
    pavucontrol
    phinger-cursors
    prismlauncher
    thonny
    # tic-80
  ];

  fonts = {
    
    enableDefaultPackages = true;

    fontDir.enable = true;

    packages = with pkgs; [
      dina-font
      fira-code
      fira-code-symbols
      liberation_ttf
      miracode
      monocraft
      mplus-outline-fonts.githubRelease
      nerd-fonts.hack
      nerd-fonts.fira-code
      nerd-fonts.droid-sans-mono
      nerd-fonts.mononoki
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-color-emoji
      proggyfonts
    ];

  };

}
