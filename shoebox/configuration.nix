# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, inputs, lib, ... }:

{
  imports = [ 
    ../modules/sway.nix
    ../modules/kiduser.nix
    
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  # Bootloader.
  boot.loader.grub = {
    enable                = true;
    enableCryptodisk      = true;
    useOSProber           = true;
    copyKernels           = true;
    efiInstallAsRemovable = true;
    efiSupport            = true;
    device                = "nodev";
    splashMode            = "stretch";
    backgroundColor       = "#0a0e14";
    configurationLimit    = 10;
    extraEntries = lib.mkAfter ''
      menuentry "Reboot" {
        reboot
      }

      menuentry "Shutdown" {
        halt
      }
    '';
  };

  boot.kernelParams = [ "quiet" ];
  boot.initrd.systemd.enable = true;
  boot.plymouth = {
    enable = true;
    theme = "breeze";
  };

  networking.hostName = "shoebox-nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/Boise";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  hardware.pulseaudio.enable = false;
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

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.andrew = {
    isNormalUser = true;
    description = "Andrew";
    extraGroups = [ "networkmanager" "video" "wheel" ];
    shell = pkgs.zsh;
    # packages = with pkgs; [
    #   firefox
    #   neovim
    #   thunderbird
    # ];
  };

  security.polkit.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  nix.settings = {
    # Enable the Flakes feature and the accompanying new nix command-line tool
    experimental-features = [ "nix-command" "flakes" ];
    
    # given the users in this list the right to specify additional substituters via:
    #    1. `nixConfig.substituters` in `flake.nix`
    #    2. command line args `--options substituters http://xxx`
    trusted-users = ["andrew"];

    substituters = [
      "https://cache.nixos.org"
    ];

    trusted-public-keys = [
      # the default public key of cache.nixos.org, it's built-in, no need to add it here
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
    ];

  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    git
    gcc
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    neovim
    wget
    curl
    # Here, the helix package is installed from the helix input data source
    inputs.helix.packages."${pkgs.system}".helix
    minetest
    firefox
    tic-80
  ];

  # Set default editor
  environment.variables.EDITOR = "nvim";

  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  environment.pathsToLink = [ "/share/zsh" ];

  # Perform garbage collection weekly to maintain low disk usage
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 1m";
  };

  # Optimize storage
  # You can also manually optimize the store via:
  #    nix-store --optimise
  # Refer to the following link for more details:
  # https://nixos.org/manual/nix/stable/command-ref/conf-file.html#conf-auto-optimise-store
  nix.settings.auto-optimise-store = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  programs.zsh.enable = true;

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?

}
