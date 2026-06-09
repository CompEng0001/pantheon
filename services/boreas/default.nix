{ config, pkgs, lib, ... }:

{
  security.polkit.enable = true;

  services.fwupd.enable = true;
  programs.niri.enable = true;

  services.apcupsd = {
    enable = true;
    configText = ''
      UPSNAME BE650G2
      UPSCABLE usb
      UPSTYPE usb
      DEVICE
    '';
  };

  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.tuigreet}/bin/tuigreet --time --cmd niri-session";
        user = "greeter";
        vt = 3;
      };
    };
  };

  services.xserver.videoDrivers = [ "nvidia" ];

#  services.udev.packages = [
#    pkgs.android-udev-rules
#  ];

  services.immich = {
    enable = true;
    host = "0.0.0.0";
    port = 8096;
    mediaLocation = "/var/lib/immich/immich-data";
    openFirewall = true;
    machine-learning.enable = false;
  };

  systemd.services.immich-server = {
    requires = [ "immich-media-setup.service" ];
    after = [ "immich-media-setup.service" ];

    unitConfig.RequiresMountsFor = [
      "/var/lib/immich"
    ];
  };

  systemd.services.immich-media-setup = {
    description = "Prepare the Immich media directory";

    before = [ "immich-server.service" ];

    unitConfig.RequiresMountsFor = [
      "/var/lib/immich"
    ];

    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };

    script = ''
      ${pkgs.coreutils}/bin/install \
        -d \
        -m 0700 \
        -o immich \
        -g immich \
        /var/lib/immich/immich-data
    '';
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
}
