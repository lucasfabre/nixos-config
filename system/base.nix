# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:

{
  imports = [
  ];

  boot.kernelPackages = pkgs.linuxPackages_zen;
  boot.kernelParams = ["quiet"];
  boot.initrd.systemd.enable = true;
  boot.tmp.cleanOnBoot = true;

  boot.plymouth = {
    enable = true;
    theme = "cross_hud";
    themePackages = [
      pkgs.adi1090x-plymouth-themes
    ];
  };

  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  # Set your time zone.
  time.timeZone = "Europe/Paris";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    # disabled at least temporarly (https://github.com/NixOS/nixpkgs/issues/257904)
    #  font = "Lat2-Terminus16";
    #  keyMap = "us";
    useXkbConfig = true; # use xkbOptions in tty.
  };

  fonts = {
    fontDir.enable = true;
    packages = with pkgs; [
      noto-fonts
      noto-fonts-emoji
    ];
  };


  # Enable CUPS to print documents.
  services.printing.enable = true;
  # Enable firmware updates by fwupd
  services.fwupd.enable = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio = {
    enable = false;
    tcp = {
      enable = true;
      anonymousClients.allowedIpRanges = ["127.0.0.1"];
    };
  };
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  hardware.bluetooth.settings = {
    General = {
      Enable = "Source,Sink,Media,Socket";
    };
  };

  services.dbus.enable = true;
  programs.noisetorch.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.lucas = {
    description = "Lucas";
    isNormalUser = true;
    createHome = true;
    shell = pkgs.zsh;
    home = "/home/lucas";
    extraGroups = [ "wheel" "networkmanager" "libvirtd" "qemu-libvirtd" ]; # Enable ‘sudo’ for the user.
    packages = with pkgs; [
      pkgs.zsh
    ];
  };

  programs.zsh.enable = true;

  security.sudo = {
    enable = true;
    extraRules = [
      { users = [ "lucas" ]; commands = [ { command =  "ALL" ; options = [ "NOPASSWD" ]; } ]; }
    ];
  };

  environment.systemPackages = with pkgs; [
    vim
    wget
    git
  ];

  services.flatpak.enable = true;

  # List services that you want to enable:
  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    settings.PermitRootLogin = "no";
  };

  # Disable the firewall
  networking.firewall.enable = false;

  programs.virt-manager.enable = true;
  virtualisation = {
    libvirtd = {
      enable = true;
    };
    podman = {
      enable = true;

      # Create a `docker` alias for podman, to use it as a drop-in replacement
      dockerCompat = true;

      # Required for containers under podman-compose to be able to talk to each other.
      defaultNetwork.settings = {
        dns_enabled = true;
      };
    };
  };

  nixpkgs.config.packageOverrides = pkgs: {
    steam = pkgs.steam.override {
      extraPkgs = pkgs: with pkgs; [
        gamescope
        mangohud

        # https://github.com/NixOS/nixpkgs/issues/162562#issuecomment-1523177264
        xorg.libXcursor
        xorg.libXi
        xorg.libXinerama
        xorg.libXScrnSaver
        libpng
        libpulseaudio
        libvorbis
        stdenv.cc.cc.lib
        libkrb5
        keyutils
      ];
    };
  };

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
  };

  nixpkgs.overlays = [
    (final: prev: {
      steam = prev.steam.override ({ extraPkgs ? pkgs': [], ... }: {
        extraPkgs = pkgs': (extraPkgs pkgs') ++ (with pkgs'; [
          libgdiplus
          gnutls
        ]);
      });
    })
  ];

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "unstable"; # Did you read the comment?

  nixpkgs.config.allowUnfree = true; 
  nix = {
    package = pkgs.nixFlakes;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };
}

