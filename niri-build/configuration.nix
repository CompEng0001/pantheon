# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, lib, pkgs, modulesPath, ... }:

{
  #imports =
  # [ # Include the results of the hardware scan.
  #   ./hardware-configuration.nix
  # ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.grub.useOSProber = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.initrd.luks.devices."luks-e37ce0b6-2e91-465f-8fb9-3884f22e9edb".device = "/dev/disk/by-uuid/e37ce0b6-2e91-465f-8fb9-3884f22e9edb";


  imports =
    [
      (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usbhid" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  swapDevices = [ ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  networking.hostName = "boreas";
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/London";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_GB.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_GB.UTF-8";
    LC_IDENTIFICATION = "en_GB.UTF-8";
    LC_MEASUREMENT = "en_GB.UTF-8";
    LC_MONETARY = "en_GB.UTF-8";
    LC_NAME = "en_GB.UTF-8";
    LC_NUMERIC = "en_GB.UTF-8";
    LC_PAPER = "en_GB.UTF-8";
    LC_TELEPHONE = "en_GB.UTF-8";
    LC_TIME = "en_GB.UTF-8";
  };

  nix.settings = {
    sandbox = true;
    cores = 0;
    auto-optimise-store = true;
    experimental-features = [ "nix-command" "flakes" ];
  };

  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.tuigreet}/bin/tuigreet --time --cmd niri-session";
        user = "greeter";
        vt = 2;
      };
    };
  };

  services.dbus.packages = [ pkgs.mako ];

  services.pipewire = {
    enable = true;
    audio.enable = true;
    alsa.enable = true;
    pulse.enable = true;
    jack.enable = true;
    wireplumber.enable = true;
    socketActivation = true;
  };

  # Configure keymap in X11
  #services.xserver.xkb = {
  #  layout = "gb";
  #  variant = "extd";
  #};

  # Configure console keymap
  console.keyMap = "uk";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  #services.pulseaudio.enable = false;
  security.rtkit.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.dev = {
    isNormalUser = true;
    description = "dev";
    extraGroups = [ "networkmanager" "wheel" "libvirtd" "video" "audio" "netdev" "pulse" "pulse-access" "adbusers" ];
    uid = 1000;
    shell = "${pkgs.zsh}/bin/zsh";
  };

  # Install firefox.
  programs.firefox.enable = true;
  programs.niri.enable = true;
  programs = {
    
    ssh = {
      startAgent = false;
    };

    bash = {
      completion.enable = true;
    };

    starship = {
      enable = true;
      settings = {
        command_timeout = 2000;
        nix_shell.disabled = false;
      };
    };

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
      shellAliases = {
        ls = "lsd";
        ip = "ip --color=auto";
        tree = "broot";
        ps = "procs";
        ack = "ag";
        less = "peep";
      };
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

  xdg.portal = {
    enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-wlr
      pkgs.xdg-desktop-portal-gtk
    ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    XDG_SESSION_TYPE = "wayland";
    MOZ_ENABLE_WAYLAND = "1";
    MOZ_USE_XINPUT2 = "1";
    SDL_VIDEODRIVER = "wayland";
    QT_QPA_PLATFORM = "wayland";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
    XKB_DEFAULT_LAYOUT = "gb";
  };
  environment.shellInit = ''
    export GPG_AGENT_INFO=$HOME/.gnupg/S.gpg-agent
    export LIBVIRT_DEFAULT_URI=qemu:///system
    export GROFF_NO_SGR=1
  '';

  environment.shells = [ pkgs.zsh ];

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    alacritty
    bat
    brave
    curl
    ffmpeg-full
    firefox-devedition
    ghostscript
    git
    grim
    gzip
    htop
    imagemagick
    jq
    kanshi
    kmon
    lsd
    mako
    man-pages
    man-pages-posix
    nix-output-monitor
    nix-update
    nixfmt
    nixpkgs-fmt
    onefetch
    openssl
    pandoc
    powertop
    pulseaudio
    pulsemixer
    quickshell
    rclone
    ripgrep
    rofi
    shellcheck
    signal-desktop
    slurp
    starship
    stow
    swaybg
    swaylock-effects
    tree
    treefmt
    ugrep
    unrar
    unzip
    urlscan
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wf-recorder
    wayland
    wayland-protocols
    ninja
    wget
    which
    whois
    wl-clipboard
    wl-mirror
    wofi
    xdg-utils
    xwayland-satellite
    zathura
    zellij
    zip
    zstd
  ];

  fonts = {
    fontconfig = {
      enable = true;
      useEmbeddedBitmaps = true;
      localConf = ''
        <?xml version='1.0'?>
        <!DOCTYPE fontconfig SYSTEM 'urn:fontconfig:fonts.dtd'>
        <fontconfig>
        <alias binding="same">
        <family>MxPlus IBM VGA 8x16</family>
        <prefer>
          <family>MxPlus IBM VGA 8x16</family>
          <family>DejaVuSansM Nerd Font</family>
        </prefer>
        </alias>
        </fontconfig>
      '';
    };
    enableGhostscriptFonts = true;
    packages = with pkgs; [
      unscii
      corefonts
      cozette
      google-fonts
      junicode
      siji
      tt2020
      ultimate-oldschool-pc-font-pack
      unifont
      vista-fonts
    ] ++ lib.filter lib.isDerivation (lib.attrValues nerd-fonts);
  };


  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.11"; # Did you read the comment?

}
