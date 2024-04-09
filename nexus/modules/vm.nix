{ config, pkgs, ... }:

{
  programs.dconf.enable = true;

  users.users.seb.extraGroups = [ "libvirtd" ];

  environment.systemPackages = with pkgs; [
    android-studio
    bridge-utils
    gnome.adwaita-icon-theme
    libvirt
    qemu_kvm
    spice
    spice-gtk
    spice-protocol
    virt-manager
    virt-viewer
    win-spice
    win-virtio
  ];

  virtualisation = {
    libvirtd = {
      enable = true;
      qemu = {
        swtpm.enable = true;
        ovmf.enable = true;
        ovmf.packages = [ pkgs.OVMFFull.fd ];
      };
      podman.enable = true;
    };
    spiceUSBRedirection.enable = true;

  };
  services.spice-vdagentd.enable = true;
}
