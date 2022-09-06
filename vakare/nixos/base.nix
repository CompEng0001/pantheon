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

    users.users.seb = {
      isNormalUser = true;
      extraGroups =
        [ "wheel" "sudo" "video" "audio" "netdev" "pulse" "pulse-access" ];
        uid= 1000;
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
            gst = "git status";
            ga = "git add";
            gaa = "git add .";
            gcm = "git commit -m";
            gpl = "git pull";
            gps = "git push";
            gd = "git diff";
            passcode = "~/.OTP/passcodes.py";
            ls = "lsd";
            cat = "bat -p";
            phd = "cd ~/Git/CCCU/PhD";
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
          cozette
          dosemu_fonts
          freefont_ttf
          google-fonts
          junicode
          nerdfonts
        ] ++ lib.filter lib.isDerivation (lib.attrValues lohit-fonts);
      };
      system.stateVersion = "22.05";
    }
