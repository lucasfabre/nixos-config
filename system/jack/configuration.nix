# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ] ++ lib.optional (builtins.pathExists ./hosts.nix) ./hosts.nix;


  # Use grub
  boot.loader = {
    timeout = 5;
    efi = {
      efiSysMountPoint = "/boot/";
      canTouchEfiVariables = true;
    };
    grub = {
        enable = true;
        efiSupport = true;
        device = "nodev";
        useOSProber = true;
        configurationLimit = 5;
    };
  };

  boot.kernelParams = ["amdgpu.ppfeaturemask=0xfff7ffff"];

  networking.hostName = "jack"; # Define your hostname.

  services.xserver.videoDrivers = ["amdgpu"];
  hardware.opengl.driSupport = true;
  hardware.opengl.driSupport32Bit = true;
  hardware.opentabletdriver.enable = true;
  boot.initrd.kernelModules = [ "amdgpu" ];
  programs.gamemode.enable = true;

  # Add amdvlk as an option
  hardware.opengl.extraPackages = with pkgs; [
    amdvlk
  ];
  # For 32 bit applications 
  # Only available on unstable
  hardware.opengl.extraPackages32 = with pkgs; [
    driversi686Linux.amdvlk
  ];

  services.power-profiles-daemon.enable = false;
}

