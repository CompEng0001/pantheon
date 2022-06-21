# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/9fd41f7d-7db1-47e7-a11d-2a5331b3df1f";
      fsType = "ext4";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/8C65-24B3";
      fsType = "vfat";
    };

  fileSystems."/mnt/storage" =
  { device = "/dev/disk/by-uuid/01D4F1DD78A199B0";
		fsType = "ntfs";
  };

  fileSystems."/mnt/networkStorage" =
  { device = "/dev/disk/by-uuid/29A61A514C7234B2";
	  fsType = "ntfs";
  };

  swapDevices = [ ];

  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";

  hardware = {
    #cpu.intel.updateMicrocode = true;
    cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
    # high-resolution display
    video.hidpi.enable = lib.mkDefault true;
    enableAllFirmware = true;
    opengl = {
      enable = true;
      extraPackages = with pkgs; [ vaapiIntel libvdpau-va-gl vaapiVdpau ];
    };

    bluetooth.enable = true;
  };

}