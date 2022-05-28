# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./packages.nix
    ./home.nix
  ];

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

  services.xserver = {
    enable = true;
    layout = "gb";
    libinput = {
      enable = true;
      touchpad.naturalScrolling = true;
      touchpad.middleEmulation = true;
      touchpad.tapping = true;
    };

    displayManager = {
      defaultSession = "none+i3";
      #lightdm.enable;
      sddm.enable = true;
      sddm.theme = "${(pkgs.fetchFromGitHub {
        owner = "CompEng0001";
        repo = "aerial-sddm-theme";
        rev = "f3a4840e08699161f61a82f104d9f7df2d29a1fe";
        sha256 = "11r74r1liib30h35gyfa8jxil5czm5gcffhfvr4cwq5nx9wbvqfq";
      })}";
    };

    windowManager.i3 = {
      enable = true;
      package = pkgs.i3-gaps;
      extraPackages = with pkgs; [
        betterlockscreen
        i3-gaps
        i3lock
        i3lock-color
        polybar
      ];
    };
  };

  nixpkgs.config = {
    packageOverrides = pkgs: rec {
      polybar = pkgs.polybar.override {
        i3GapsSupport = true;
        i3Support = true;
				githubSupport = true;
        pulseSupport = true;
      };
    };
  };
  
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
    socketActivation = true;
  };

  users.users.seb = {
    isNormalUser = true;
    extraGroups = [ "wheel" "sudo" "video" "audio" "netdev" "pulse" "pulse-access" ];
  };

  systemd.tmpfiles.rules = [
    "d /mnt/ 0755 root root"
    "d /home/seb/Music 0755 seb users"
    "d /home/seb/Git 0755 seb users"
    "d /home/seb/Documnets 0755 seb users"
  ];

  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowUnsupportedSystem = true;

  programs = {
    bash = {
      enableCompletion = true;
      enableLsColors = true;
      promptInit = ''
        eval "$(${pkgs.starship}/bin/starship init bash)"
      '';
      shellAliases = {
        config = "sudo nano /etc/nixos/configuration.nix";
        ls = "lsd";
        ll = "lsd -l";
        l = "lsd -lah";
      };
    };
    nano = {
      syntaxHighlight = true;
      nanorc = ''
        set autoindent
        set nowrap
        set tabsize 2
        set linenumbers
        set nonewlines
      '';
    };
  };

  fonts = {
    fontconfig = {
      enable = true;
      useEmbeddedBitmaps = true;
    };
    enableGhostscriptFonts = true;
    fonts = with pkgs; [
      clearlyU
      fixedsys-excelsior
      cm_unicode
      cozette
      dosemu_fonts
      freefont_ttf
      google-fonts
      junicode
      nerdfonts
    ] ++ lib.filter lib.isDerivation (lib.attrValues lohit-fonts);
  };
  system.stateVersion = "21.11";
}
