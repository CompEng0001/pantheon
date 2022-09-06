{ config, pkgs, lib, ... }:

{
  virtualisation = {
    virtualbox = {
      host = {
        enable = true;
        enableHardening = true;
      };
    };
    libvirtd = { enable = true; };
  };

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
  services.spotifyd = {
    enable = true;
    settings ={
      global = {
        username = "sb1501@canterbury.ac.uk";
        password = "Insilico1";
        device_name = "aitvaras";
        proxy = "http://localhost:8888";
      };
    };
  };
  services.mysql = {
    enable = true;
    user = "seb";
    package = pkgs.mysql80;
    settings.mysqld = {
      port = 1337;
      secure_file_priv ="";
      local_infile = 1;
    };
    settings.mysql = {
      local_infile = 1;
    };
  };
}
