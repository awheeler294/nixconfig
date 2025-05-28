# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports = [ 
    # Include the results of the hardware scan.
    ./hardware-configuration.nix

    ../modules/common-base.nix
    ../modules/common-gui.nix
    
    ../modules/sway.nix
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "vaulty-server"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

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

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define storage group
  users.groups.storage = {
    gid = 1001;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users = {
    
    andrew = {
      extraGroups = [ "storage" ];
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIM3zhxrXqDdLFcBZiX3zje257i6w3NJnRyPgHyEIhKMh andrew@proxy-server"
      ];
    };

    storage = {
      isSystemUser = true;
      group = "storage";
    };
    
  };

  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
  };

  # Install firefox.
  programs.firefox.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    ddrescue
    docker-compose
    e2fsprogs # badblocks
    gnumake
    gnupg
    gptfdisk
    hddtemp
    intel-gpu-tools
    inxi
    iotop
    lm_sensors
    mergerfs
    mc # Midnight Commander, a File Manager and User Shell for the GNU Project
    nmap
    nvme-cli
    pinentry-curses
    podman-tui
    smartmontools
    snapraid
    # snapraid-runner
    tdns-cli # DNS tool that aims to replace dig and nsupdate
    wireguard-tools
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

  services.pcscd.enable = true;
  programs.gnupg.agent = {
     enable = true;
     enableSSHSupport = true;
     pinentryPackage = pkgs.pinentry-curses;
  };

  services.snapraid = {
    enable = true;
    sync.interval = "";
    scrub.interval = "";
    contentFiles = [
      "/var/snapraid.content"
      "/mnt/disk1/snapraid.content"
      "/mnt/disk2/snapraid.content"
      "/mnt/disk3/snapraid.content"
      "/mnt/disk4/snapraid.content"
    ];
    dataDisks = {
      d1 = "/mnt/disk1/";
      d2 = "/mnt/disk2/";
      d3 = "/mnt/disk3/";
      d4 = "/mnt/disk4/";
    };
    parityFiles = [
      "/mnt/parity1/snapraid.parity"
    ];
    exclude = [
      "*.unrecoverable"
      "/tmp/"
      "/lost+found/"
      "*.!sync"
      "/.snapshots/"
    ];
  };

  systemd.services.NetworkManager-wait-online.enable = false;

  systemd.services."snapraid-runner" = {
    script = ''
      set -eu
      ${pkgs.python3}/bin/python3 /opt/snapraid-runner/snapraid-runner.py -c /root/snapraid-runner.conf
    '';
    serviceConfig = {
      Type = "oneshot";
      User = "root";
    };
  };

  systemd.timers."snapraid-runner" = {
  wantedBy = [ "timers.target" ];
    timerConfig = {
      # Daily at 4am
      OnCalendar = "*-*-* 04:00:00";
      Unit = "snapraid-runner.service";
    };
  };

  virtualisation = {
    # Enable common container config files in /etc/containers
    containers.enable = true;
    
    docker = {
      enable = true;
      autoPrune = {
        enable = true;
        dates = "weekly";
      };
    };
  
    podman = {
      enable = true;

      # Create a `docker` alias for podman, to use it as a drop-in replacement
      #dockerCompat = true;

      # Required for containers under podman-compose to be able to talk to each other.
      defaultNetwork.settings.dns_enabled = true;
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
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = false;

  ###
  # Wireguard Setup
  ###
  networking.firewall = {
    allowedUDPPorts = [ 51820 ]; # Clients and peers can use the same port, see listenport
  };
  # Enable WireGuard
  networking.wireguard.enable = true;
  networking.wireguard.interfaces = let
    proxy_server_public_key = "MmqD60klDC+ZBEOfIUCTgsaHctLVKw+9TWuP3WIc5Fk=";
  in {
    # "wg0" is the network interface name. You can name the interface arbitrarily.
    wg0 = {
      # Determines the IP address and subnet of the client's end of the tunnel interface.
      ips = [ "10.100.0.2/24" ];
      listenPort = 51820; # to match firewall allowedUDPPorts (without this wg uses random port numbers)

      # Path to the private key file.
      #
      # Note: The private key can also be included inline via the privateKey option,
      # but this makes the private key world-readable; thus, using privateKeyFile is
      # recommended.
      privateKeyFile = "/root/wireguard-keys/private";
      postSetup = ''
        wg set wg0 peer ${proxy_server_public_key } persistent-keepalive 25
      '';

      peers = [
        # For a client configuration, one peer entry for the server will suffice.

        {
          # Public key of the server (not a file path).
          publicKey = proxy_server_public_key;

          # Forward all the traffic via VPN.
          # allowedIPs = [ "0.0.0.0/0" ];
          # Or forward only particular subnets
          #allowedIPs = [ "10.100.0.1" "91.108.12.0/22" ];
          allowedIPs = [ "10.100.0.0/24" ];

          # Set this to the server IP and port.
          endpoint = "45.32.229.198:51820"; # ToDo: route to endpoint not automatically configured https://wiki.archlinux.org/index.php/WireGuard#Loop_routing https://discourse.nixos.org/t/solved-minimal-firewall-setup-for-wireguard-client/7577

          # Send keepalives every 25 seconds. Important to keep NAT tables alive.
          persistentKeepalive = 25;
        }
      ];
    };
  };

  services.samba = {
    enable = true;
    openFirewall = true;
    settings = {
      global = {
        "workgroup" = "WORKGROUP";
        "server string" = "vaulty-server";
        "netbios name" = "vaulty-server";
        "security" = "user";
        #"use sendfile" = "yes";
        #"max protocol" = "smb2";
        # note: localhost is the ipv6 localhost ::1
        # "hosts allow" = "192.168.0. 127.0.0.1 localhost";
        # "hosts deny" = "0.0.0.0/0";
        "guest account" = "nobody";
        "map to guest" = "bad user";
      };
      "storage" = {
        "path" = "/mnt/storage/Storage";
        "browseable" = "yes";
        "read only" = "no";
        "guest ok" = "yes";
        "create mask" = "0664";
        "directory mask" = "0775";
        "force user" = "storage";
        "force group" = "storage";
      };
    };
  };

  services.samba-wsdd = {
    enable = true;
    openFirewall = true;
  };

  # networking.firewall.enable = true;
  networking.firewall.allowPing = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?

}
