# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib,  ... }:

{

  services.udev.extraRules = ''
    ACTION=="add", 
    SUBSYSTEM=="backlight", 
    KERNEL=="intel_backlight", 
    MODE="0666", 
    RUN+="${pkgs.coreutils}/bin/chmod a+w /sys/class/backlight/intel_backlight/brightness"
  '';
  
  services.xserver = {
    enable = true;
    layout = "gb";
    libinput = {
      enable = true;
      touchpad.naturalScrolling = true;
      touchpad.middleEmulation = true;
      touchpad.tapping = true;
    };

    displayManager = {
      defaultSession = "none+i3";
      #lightdm.enable;
      sddm.enable = true;
      sddm.theme = "${(pkgs.fetchFromGitHub {
        owner = "CompEng0001";
        repo = "my-sddm-theme";
        rev = "30fbf93746e8069c6d714c6c491c99abd0cf995e";
        sha256 = "1ga4qvrqqj68lyx6sqbl0wz64vb20xbv2fl2879v0k3kv3h60wa4";
      })}";
    };

    windowManager.i3 = {
      enable = true;
      package = pkgs.i3-gaps;
      extraPackages = with pkgs; [
        betterlockscreen
        i3-gaps
        i3lock
        i3lock-color
        polybar
      ];
    };
  };

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
    socketActivation = true;
  };
}
