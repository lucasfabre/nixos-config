# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:

{
   imports = [
     ./hardware-configuration.nix
   ] ++ lib.optional (builtins.pathExists ./hosts.nix) ./hosts.nix;

  # Use systemd-boot
  boot.loader = {
    systemd-boot = {
      enable = true;
    };
    timeout = 5;
    efi = {
      efiSysMountPoint = "/boot/";
      canTouchEfiVariables = true;
    };
  };

  networking.hostName = "framework";
  boot.initrd.availableKernelModules = ["tpm_crb"];

  # Enable touchpad support (enabled default in most desktopManager).
  services.xserver.libinput.enable = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
  ];

  services.fprintd.enable = true;

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [ ];
  networking.firewall.allowedUDPPorts = [ ];
}

