{ config, pkgs, ... }:

{
  programs.dconf.enable = true;

  users.users.dev.extraGroups = [ "libvirtd" ];

  environment.systemPackages = with pkgs; [
    adwaita-icon-theme
    bridge-utils
    libvirt
    qemu_kvm
    swtpm
    virt-manager
    virt-viewer
  ];

  virtualisation = {
    libvirtd.qemu.swtpm.enable = true;
    virtualbox = {
      host = {
        enable = false;
        enableHardening = false;
      };
    };
    libvirtd = {
      enable = true;
      qemu.package = pkgs.qemu_kvm;
    };
    podman.enable = true;
  };
}
