{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  # Initrd modules
  boot.initrd.availableKernelModules =
    [ "xhci_pci" "vmd" "nvme" "usb_storage" "sd_mod" "rtsx_pci_sdmmc" ];
  boot.initrd.kernelModules = [ "evdi" ];

  # Kernel modules
  boot.kernelModules = [ "kvm-intel" ];         # added evdi
  boot.extraModulePackages = [ config.boot.kernelPackages.evdi ]; # added evdi DKMS package

  # Filesystems
  fileSystems."/" = {
    device = "/dev/disk/by-uuid/15c706fe-eca3-46e4-8279-de18a9b93576";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/21E9-B1EC";
    fsType = "vfat";
    options = [ "fmask=0077" "dmask=0077" ];
  };

  swapDevices =
    [{ device = "/dev/disk/by-uuid/ce9faa0d-fa1a-446b-9df0-637bea3a7324"; }];

  # Power management
  powerManagement = {
    cpuFreqGovernor = lib.mkDefault "powersave";
    powertop.enable = true;
  };

  # Hardware config
  hardware = {
    cpu.intel.updateMicrocode =
      lib.mkDefault config.hardware.enableRedistributableFirmware;

    enableAllFirmware = true;

    graphics = {
      enable = true;
      extraPackages = with pkgs; [
        intel-vaapi-driver
        libvdpau-va-gl
        libva-vdpau-driver
        mesa
        libGL
      ];
    };

    bluetooth.enable = true;
    
  };
}
