# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:

{
  security.polkit.enable = true;

  services.fwupd.enable = true;

  services.udev.extraRules = ''
    ACTION=="add",
    SUBSYSTEM=="backlight",
    KERNEL=="intel_backlight",
    MODE="0666",
    RUN+="${pkgs.coreutils}/bin/chmod a+w /sys/class/backlight/intel_backlight/brightness"
  '';

  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
    extraPackages = with pkgs; [
      grim
      kooha
      slurp
      rofi-wayland
      alacritty
      waybar
      swayidle
      swaylock-effects
      wl-clipboard
      swaybg
    ];
  };

  services.geoclue2 = {
    enable = true;
    enableWifi = true;
  };

  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd sway";
        user = "greeter";
        vt = 1;
      };
    };
  };

  systemd.user.services.kanshi = {
    description = "Kanshi output autoconfig ";
    wantedBy = [ "graphical-session.target" ];
    partOf = [ "graphical-session.target" ];
    serviceConfig = {
      # kanshi doesn't have an option to specifiy config file yet, so it looks
      # at .config/kanshi/config
      ExecStart = ''
        ${pkgs.kanshi}/bin/kanshi -c /home/seb/.config/kanshi/config
      '';
      RestartSec = 5;
      Restart = "always";
    };
  };

  services.udev.packages = [
    pkgs.android-udev-rules
  ];

  services.dbus.packages = [ pkgs.mako ];

  services.pipewire = {
    enable = true;
    audio.enable = true;
    alsa.enable = true;
    pulse.enable = true;
    jack.enable = true;
    wireplumber.enable = true;
    socketActivation = true;
  };

  services.mosquitto = {
    enable = true;
    listeners = [
      {
        port = 1883;
      }

    ];
  };

  services.mysql = {
    enable = true;
    user = "seb";
    package = pkgs.mysql80;
    settings.mysqld = {
      port = 1337;
      secure_file_priv = "";
      local_infile = 1;
      autocommit = 0;
    };
    settings.mysql = {
      local_infile = 1;
    };
  };
}
