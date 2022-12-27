{ config, pkgs, lib, ... }:

{
  virtualisation = {
    libvirtd = {
      enable = true;
      qemu.package = pkgs.qemu_kvm;
    };
    podman.enable = true;
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
      setupCommands = ''
      MAIN='DP-1'
      VERTICAL='HDMI-2'
      ${pkgs.xorg.xrandr}/bin/xrandr --output $VERTICAL --mode 1920x1080 --right-of $MAIN --rotate right
      '';

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

  services.mysql = {
    enable = true;
    user = "seb";
    package = pkgs.mysql80;
    settings.mysqld = {
      port = 1337;
      secure_file_priv = "";
      local_infile = 1;
      autocommit =0;
    };
    settings.mysql = {
      local_infile = 1;
    };
  };
}
