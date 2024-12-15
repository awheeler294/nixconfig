# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [
      ../modules/sway.nix

      # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "proxy-server"; # Define your hostname.
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

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
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
    description = "andrew";
    extraGroups = [ "networkmanager" "wheel" "storage" "disk" "video" "docker" ];
    packages = with pkgs; [
    #  thunderbird
    ];
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDDL/+YvaXuscTQBocwWcSn0ZBRGZ20B2TdUzYgFqiqXy5LXXF2v193UGk0WUXW0jHLxuU5FqFbf9gVrQShyp6LzzGkZRYD/blMtCcYMS0zkFVl86imtA898nrqlr6X/+MhZc7gw+TMgfogkttriytyfbWkTnDXAthVEXtpdkXcvLH3Z8mK5Me5zMMrt4I9JvgolNGTqWkkpzpVYWjLjH+RXOcrgkYG3ptD2tvmI+4TEzXl8T+OrQsandjzjIKD3o+vIn616qVFncyvTBZdcQQ3XAMCB+234tpQOaq98LeJTe6xOCEyur/ZwlFkyAibcEAS4IIPLvou5wZAUXq0bE+l/Jp8uv3GBw7IiR7edHrywZLdP4UNAS3KnJ8tkHtfHzX3haQz5NrRbuTeTwAiB64K0GrzKHzG39KDkYvJX0cK//AevEXUKAnsK2gSt7GGIp3D5okhnin+1nQdY0QDIVvllb8NA2ghO0Qxpcf/DB2vODey0hngvHgCUWicItyyxxU="
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC89HhgaHv/jMfx9J6CRY6DWE/6L2v4W9CEa3PLGHXGUAYif2bF1XUrI+c6wGgsuHvPNxUAf8bdYEJirHcD3/cy3p2TUNS0V4Hx6sm4odTBYnbE9N31Jd5OBXojFALf5yRgennx1G07uoHI2ww8SF9Dzcy3dUJ4N6HNdq+X47hxp4HoD+3ZOOcOWyKEuVjuNaUMSTvjQWP+f4/NUVOW+tP1wpnXcdFCSCxb8IcJaA5HKd/gbWK/CqJvQYIpNbXd0ocdzaNzGXk0RbfLaRZ3yzwMfWM+Nb3WO7hwiFnyw5XIsjPvxb2tw+NAftkzAE6DJ2PnnETAE9PNZGulL7452cvgONszbxWKK40otQ+AhgVFisRzJ7IDiTKPsbA0BYfxYzkQUmQ3t/Q39Q2IlBQAh2BPqhPBv/wV9wvXBVdJL2ohCYScH9kHeM0dapo9eFTDGMNYD+VU59O+csCJgNcn/PSXL0k0/ZDLp+MYFlS7UXKgEZSu8jdKei0DQ43nrz7lXxE="
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDsHRP09y93tYaK2izli1LkSkEtt6Gpgo2/WZo3aduNgz6VlncoF5MCvEdN3Tp/novZ+D8E0NVNMVntOKbzdVizkj7IL6WVHyjxOZvZXSL2jG+HvC60Y1ek0oFVGRR0RiZkV6aUn56nxrQAMhw8EO8Rgc9aGyaLPJ6ZiFk4q5y7YE4n19PFVMtuzKuK3iO09+ID81iTgH53PF3+RQ9VB7N4s9G1Xxt/UzR1h4iqdTDWWiColMqbqxTvijwwmjXD3fiB8Jd6NzEO7UFtU0o8Dlb5ooXW08mP1P0ssH1T7IBKXEI6E9irIIQZ7Fv3WnG5jcmZ3UV2t4mzcCTtIUS0HOYqXBOhSE47Pg5CDLuR1Z2NKH8Qeo9wzUU1gKT4PTxqrSpDoFHU33GdaJGHrN+dIp5AIsH+DiDMP6lIB84M+gnESGyfHmt6SGNXNRUtaW/lTVLcN1hN9tKJwXn3+wIBPbvJV1/w2IRrvNtlJIKDV+RKNGacHoopLb5pCxCutD25lhE="
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDchBqOb+/l3eI6hGOQgYIYlhaRlmFptkS2wUq8AyQ8e"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJTvC8zbRAPQqKzrgtrPU/pjpDa3cYEu6gGg1qo8A6gb"
    ];
  };

  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
  };

  # Install firefox.
  # programs.firefox.enable = true;

  # Allow unfree packages
  # nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    alacritty
    btop
    curl
    docker-compose
    eza
    fd
    gcc
    git
    htop
    iotop
    jq
    mc
    ncdu
    neovim
    nmap
    nvme-cli
    python3
    sanoid
    smartmontools
    sway
    tdns-cli
    tmux
    tree
    vim
    wget
    zsh
  ];

  fonts.packages = with pkgs; [
    (nerdfonts.override { fonts = [ "Hack" "FiraCode" "DroidSansMono" "Mononoki"]; })
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = false;
    settings.PermitRootLogin = "no";
  };

  virtualisation = {
    docker = {
      enable = true;
      autoPrune = {
        enable = true;
        dates = "weekly";
      };
    };
  };

  systemd.services.start-docker-compose = {
    script = ''
      ${pkgs.docker-compose}/bin/docker-compose -f /opt/docker-compose.yml up -d
    '';
    wantedBy = ["multi-user.target"];
    # If you use podman
    # after = ["podman.service" "podman.socket"];
    # If you use docker
    after = ["docker.service" "docker.socket"];
  };

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [ 80 443 ];
  networking.firewall.allowedUDPPorts = [ ];
  # Or disable the firewall altogether.
  networking.firewall.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?

}
