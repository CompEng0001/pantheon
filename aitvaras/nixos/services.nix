{ config, pkgs, lib, ... }:

{
  virtualisation = {
    libvirtd = {
      enable = true;
      qemu.package = pkgs.qemu_kvm;
    };
    podman.enable = true;
  };

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
    ];
  };

  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd sway";
        user = "greeter";
        vt = 3;
      };
    };
  };

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
