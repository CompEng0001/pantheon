# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:

{
  boot = {
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
  };

  time.timeZone = "Europe/London";
  networking = {
    hostName = "scirocco";
    useNetworkd = true;
    interfaces.wlan0.useDHCP = true;
    firewall.enable = false;
    wireless.iwd.enable = true;
  };

  i18n.defaultLocale = "en_GB.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "uk";
  };

  users.users.dev = {
    isNormalUser = true;
    extraGroups =
      [ "wheel" "libvirtd" "video" "audio" "netdev" "pulse" "pulse-access" "adbusers" ];
    uid = 1000;
    shell = "${pkgs.zsh}/bin/zsh";
  };

  programs.niri.enable = true;
# programs.sway = {
#    enable = true;
#    wrapperFeatures.gtk = true;
#    extraPackages = with pkgs; [
#      alacritty
#      firefox-devedition
#      grim
#      kanshi
#      rofi-wayland
#      slurp
#      swaybg
#      swayidle
#      swaylock-effects
#      waybar
#      wl-clipboard
#      wlr-randr
#`    ];
#  };
  programs.git.enable = true;
  nixpkgs.config.allowUnfree = true;

  systemd.tmpfiles.rules = [
    "d /mnt/ 0755 root root"
    "d /mnt/usb-right1/ 0755 root root"
    "d /mnt/usb-right2/ 0755 root root"
    "d /mnt/usb-left/ 0755 root root"
    "d /mnt/usbc/ 0755 root root"
    "d /mnt/microSD/ 0755 root root"
    "d /home/dev/Music 0755 seb users"
    "d /home/dev/Git 0755 seb users"
  ];

  nix.settings = {
      auto-optimise-store = true;
      experimental-features = [ "nix-command" "flakes" ];
  };

  environment = {
    sessionVariables = {
      NIXOS_OZONE_WL = "1";
      XDG_SESSION_TYPE = "wayland";
      MOZ_ENABLE_WAYLAND = "1";
      MOZ_USE_XINPUT2 = "1";
      SDL_VIDEODRIVER = "wayland";
      QT_QPA_PLATFORM = "wayland-egl"; # NVIDIA
      QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
      XKB_DEFAULT_LAYOUT = "gb";
    };

    shellInit = ''
      export GPG_AGENT_INFO=$HOME/.gnupg/S.gpg-agent
      export LIBVIRT_DEFAULT_URI=qemu:///system
      export LS_COLORS="$(vivid generate snazzy)"
      export EDITOR='vim'
    '';
    shells = [ pkgs.zsh ];

  };

  xdg.portal = {
    enable = true;
  };

  programs = {
    zsh = {
      enable = true;
      autosuggestions.enable = true;
      promptInit = ''
        eval "$(${pkgs.starship}/bin/starship init zsh)"
        ${pkgs.any-nix-shell}/bin/any-nix-shell zsh --info-right | source /dev/stdin

        # Custom Aliases
        if [ -f ~/.config/zsh/aliases.zsh ]; then
          source ~/.config/zsh/aliases.zsh
        fi
      '';
	
      interactiveShellInit = ''
        zstyle ':completion:*' menu select
        source ${pkgs.fzf}/share/fzf/key-bindings.zsh
      '';

      setOptions = [
        "auto_cd"
        "auto_pushd"
        "correct"
        "hist_fcntl_lock"
        "hist_ignore_dups"
        "hist_no_store"
        "hist_reduce_blanks"
      ];
    };

  };

  fonts = {
    fontconfig = {
      enable = true;
      useEmbeddedBitmaps = true;
    };
    enableGhostscriptFonts = true;
    packages = with pkgs;
      [
        clearlyU
        fixedsys-excelsior
        cm_unicode
        corefonts
        cozette
        dosemu_fonts
        freefont_ttf
        google-fonts
        junicode
        siji
        tt2020
        ultimate-oldschool-pc-font-pack
        unifont
        wqy_microhei
      ] ++ lib.filter lib.isDerivation (lib.attrValues lohit-fonts ++ lib.attrValues nerd-fonts);
  };
  system.stateVersion = "25.05";
}
