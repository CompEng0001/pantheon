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
        vt = 1;
      };
    };
  };

#  services.udev.packages = [
#    pkgs.android-udev-rules
#  ];

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
