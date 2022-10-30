# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  boot = {
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
    # kernelPackages = pkgs.linuxPackages_lastest;
  };

  time.timeZone = "Europe/London";
  networking = {
    hostName =
      "vakare"; # Define your hostname.  Lithuanian Goddess of the evening star
    useDHCP = false;
    interfaces.wlan0.useDHCP = true;
    firewall.enable = false;
    wireless.iwd.enable = true;
  };

  i18n.defaultLocale = "en_GB.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "uk";
  };

  users.users.seb = {
    isNormalUser = true;
    extraGroups =
      [ "wheel" "libvirtd" "video" "audio" "netdev" "pulse" "pulse-access" ];
    uid = 1000;
    shell = "${pkgs.zsh}/bin/zsh";
  };

  systemd.tmpfiles.rules = [
    "d /mnt/ 0755 root root"
    "d /mnt/usb-right1/ 0755 root root"
    "d /mnt/usb-right2/ 0755 root root"
    "d /mnt/usb-left/ 0755 root root"
    "d /mnt/usbc/ 0755 root root"
    "d /mnt/microSD/ 0755 root root"
    "d /home/seb/Music 0755 seb users"
    "d /home/seb/Git 0755 seb users"
  ];

  nix = {
    extraOptions = ''
      experimental-features = nix-command
    '';
  };

  environment = {
    shellInit = ''
      export LIBVIRT_DEFAULT_URI=qemu:///system
      export EDITOR='vim'
    '';
    shells = [ pkgs.zsh ];
  };

  programs = {
    zsh = {
      enable = true;
      promptInit = ''
        eval "$(${pkgs.starship}/bin/starship init zsh)"
        ${pkgs.any-nix-shell}/bin/any-nix-shell zsh --info-right | source /dev/stdin
      '';

      interactiveShellInit = ''
        zstyle ':completion:*' menu select
        source ${pkgs.fzf}/share/fzf/key-bindings.zsh
      '';

      autosuggestions.enable = true;

      setOptions = [
        "auto_cd"
        "auto_pushd"
        "correct"
        "hist_fcntl_lock"
        "hist_ignore_dups"
        "hist_no_store"
        "hist_reduce_blanks"
      ];

      shellAliases = {
        # [[GIT]]
        ga = "git add";
        gaa = "git add .";
        gcm = "git commit -m";
        gd = "git diff";
        gitcheck = "~/.config/scripts/python/gitcheck.py -d ~/Git/ -f --recursive -b ''";
        glg = "git log --graph --oneline --decorate --all";
        gpl = "git pull";
        gps = "git push";
        gst = "git status --short";
        # [[SYSTEM]]
        cat = "bat -p";
        ls = "lsd";
        kanban = "xdg-open https://github.com/users/CompEng0001/projects/2 &&";
        mdbook-uni = "mdbook serve . -p 8000 12.0.0.1"
        passcode = "~/.OTP/passcodes.py";
        phd = "cd ~/Git/CCCU/PhD";
        pantheon = "cd ~/Git/personal/pantheon";
        wifi = "~/.config/scripts/bash/wifi.sh";
      };
    };
  };

  fonts = {
    fontconfig = {
      enable = true;
      useEmbeddedBitmaps = true;
    };
    enableGhostscriptFonts = true;
    fonts = with pkgs;
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
        nerdfonts
        siji
        tewi-font
        tt2020
        ultimate-oldschool-pc-font-pack
        unifont
        vistafonts
        wqy_microhei
      ] ++ lib.filter lib.isDerivation (lib.attrValues lohit-fonts);
  };
  system.stateVersion = "22.05";
}
