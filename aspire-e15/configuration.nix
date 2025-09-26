# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, inputs, lib, ... }:

{
  imports = [ 
    # Include the results of the hardware scan.
    ./hardware-configuration.nix

    ../modules/common-base.nix
    ../modules/common-gui.nix
    
    ../modules/sway.nix
    ../modules/kiduser.nix
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
  boot.initrd.kernelModules = [ "nfs" ];
  boot.plymouth = {
    enable = true;
    theme = "breeze";
  };

  networking.hostName = "aspire-e15-nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = false;
    settings.PermitRootLogin = "no";
  };

  # Enable automatic login for the user.
  services.displayManager.autoLogin.enable = lib.mkForce true;
  services.displayManager.autoLogin.user = lib.mkForce "andrew";
  services.displayManager.defaultSession = lib.mkForce "sway";

  # users.users.andrew = {
  #   openssh.authorizedKeys.keys = [
  #     "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIM3zhxrXqDdLFcBZiX3zje257i6w3NJnRyPgHyEIhKMh andrew@proxy-server"
  #   ];
  # };
  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  environment.systemPackages = with pkgs; [
    qbittorrent
    pkgs.cifs-utils #For mount.cifs, required unless domain name resolution is not needed.
  ];

  # Network Drive Mounts
  fileSystems."/mnt/vaulty-server" = {
    device = "//192.168.1.5/storage";
    fsType = "cifs";
    options = let
      # this line prevents hanging on network split
      automount_opts = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s";

    in ["${automount_opts},credentials=/etc/nixos/smb-secrets"];
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?

}
