{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}:

{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot = {
    extraModulePackages = [ ];
    kernelModules = [ "kvm-intel" ];
    kernelPackages = pkgs.linuxPackages_latest;
  };

  boot.initrd = {
    availableKernelModules = [
      "xhci_pci"
      "ahci"
      "nvme"
      "usbhid"
      "usb_storage"
      "sd_mod"
    ];
    kernelModules = [ ];
    luks.devices = {
      "luks-2333e31c-46b0-4b18-acd0-cef29df28f98".device =
        "/dev/disk/by-uuid/2333e31c-46b0-4b18-acd0-cef29df28f98";

      "luks-e37ce0b6-2e91-465f-8fb9-3884f22e9edb".device =
        "/dev/disk/by-uuid/e37ce0b6-2e91-465f-8fb9-3884f22e9edb";
    };
  };

  boot.loader = {
    efi.canTouchEfiVariables = true;
    #grub.useOSProber = true;
    systemd-boot.enable = true;
  };

  fileSystems."/" = {
    device = "/dev/mapper/luks-2333e31c-46b0-4b18-acd0-cef29df28f98";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/0C49-8B2B";
    fsType = "vfat";
    options = [
      "fmask=0077"
      "dmask=0077"
    ];
  };

  swapDevices = [ { device = "/dev/mapper/luks-e37ce0b6-2e91-465f-8fb9-3884f22e9edb"; } ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  hardware = {
    cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

    enableAllFirmware = true;

    graphics = {
      enable = true;
      extraPackages = with pkgs; [
        intel-vaapi-driver
        libvdpau-va-gl
        libva-vdpau-driver
        nvidia-vaapi-driver
      ];
    };

    bluetooth.enable = true;

    nvidia = {

      open = false;
      modesetting.enable = true;
      powerManagement.enable = true;
      nvidiaSettings = true;
      nvidiaPersistenced = true;
      package = config.boot.kernelPackages.nvidiaPackages.stable;

    };
  };

}
