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
    hostName = "aitvaras"; # Define your hostname.  Lithuanian spirit
    useDHCP = false;
    interfaces.enp0s31f6.useDHCP = true;
    firewall.enable = false;
  };

  i18n.defaultLocale = "en_GB.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "uk";
  };

  nix.settings = {
    sandbox = true;
    cores = 0;
    auto-optimise-store = true;
    experimental-features = [ "nix-command" "flakes" ];
  };

  users.users.seb = {
    isNormalUser = true;
    extraGroups = [ "wheel" "libvirtd" "video" "audio" "netdev" "pulse" "pulse-access" ];
    uid = 1000;
    shell = "${pkgs.zsh}/bin/zsh";
  };

  systemd.tmpfiles.rules = [
    "d /mnt/ 0755 root root"
    "d /home/seb/Music 0755 seb users"
    "d /home/seb/Git 0755 seb users"
    "d /home/seb/Documents 0755 seb users"
  ];

  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowUnsupportedSystem = true;


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
        #[GIT]
        ga = "git add";
        gaa = "git add .";
        gcm = "git commit -m";
        gd = "git diff";
        gitcheck = "~/.config/scripts/python/gitcheck.py -d ~/Git/  -f --recursive -b ''";
        glg = "git log --graph --oneline --decorate --all";
        gpl = "git pull";
        gps = "git push";
        gst = "git status --short";
        #[OTHERS]
        cat = "bat -p";
        kanban = "xdg-open https://www.github.com/CompEng0001/projects/2 &";
        ls = "lsd";
        mdbook-uni = "mdbook serve . -p 8000 -n 127.0.0.1";
        pantheon = "cd ~/Git/personal/pantheon";
        passcode = "~/.OTP/passcodes.py";
        phd = "cd ~/Git/CCCU/PhD";
      };
    };
  };

  environment = {
    sessionVariables = {
      XDG_SESSION_TYPE = "wayland";
      XDG_CURRENT_DESKTOP = "sway";
      MOZ_ENABLE_WAYLAND = "1";
      MOZ_USE_XINPUT2 = "1";
      SDL_VIDEODRIVER = "wayland";
      QT_QPA_PLATFORM = "wayland-egl";
      QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
      XKB_DEFAULT_LAYOUT = "gb";
    };
    shellInit = ''
      export GPG_AGENT_INFO=$HOME/.gnupg/S.gpg-agent
      export LIBVIRT_DEFAULT_URI=qemu:///system
      export LS_COLORS="$(vivid generate snazzy)"
      export LESS_TERMCAP_mb=$'\E[1;31m'
      export LESS_TERMCAP_md=$'\E[1;36m'
      export LESS_TERMCAP_me=$'\E[0m'
      export LESS_TERMCAP_so=$'\E[01;33m'
      export LESS_TERMCAP_se=$'\E[0m'
      export LESS_TERMCAP_us=$'\E[1;32m'
      export LESS_TERMCAP_ue=$'\E[0m'
      export EDITOR='vim'
    '';
    shells = [ pkgs.zsh ];
  };

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [ xdg-desktop-portal-wlr xdg-desktop-portal-gtk ];
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
  system.stateVersion = "22.11";
}
