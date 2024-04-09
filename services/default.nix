{ config, pkgs, lib, ... }:

{
  security.polkit.enable = true;

  services.fwupd.enable = true;

  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
    extraPackages = with pkgs; [
      alacritty
      grim
      kooha
      rofi-wayland
      slurp
      swaybg
      swayidle
      swaylock-effects
      waybar
      wl-clipboard
      wlr-randr
    ];
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
