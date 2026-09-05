# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:

{
  services.hardware.bolt.enable = true;

  services.geoclue2 = {
    enable = true;
    enableWifi = true;
  };
  services.xserver.videoDrivers = [
    "modesetting"
    #"displaylink"

  ];

  services.xserver.xkb = {
    layout = "gb";
    variant = "";
  };
  systemd.services.dlm.wantedBy = [ "multi-user.target" ];
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

  services.greetd ={
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.tuigreet}/bin/tuigreet --time --cmd niri-session";
        user = "greeter";
        vt = "1";
      };
    };
  };

  services.openssh = {
    enable = true;
    # ports = [ 22 ]; # Port 22 is used by default if not specified
  };

  services.immich = {
    enable = true;
    port = 8096;
    host = "0.0.0.0";
    mediaLocation = "/var/lib/immich";
    openFirewall = true;
  };


 # environment.systemPackages = with pkgs; [
 #   displaylink
 # ];

  services.gvfs.enable = true; # mtp file transfer android
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

}
