# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ pkgs, ... }: {

  nixpkgs.config = {
    packageOverrides = pkgs: rec {
      polybar = pkgs.polybar.override {
        i3GapsSupport = true;
        i3Support = true;
        githubSupport = true;
        pulseSupport = true;
      };
    };
    allowUnfree = true;
    allowUnsupportedSystem = true;
    mpv = { youtubeSupport = true; };
    permittedInsecurePackages = [
      "python3.9-mistune-0.8.4"
    ];
  };

  environment.systemPackages = with pkgs; [

    # [[EDITORS]]
    arduino
    (pkgs.callPackage ./vim.nix { })
    vscode
    jetbrains.idea-community
    # [[INTERNET]]
    brave
    chromium
    nmap
    speedtest-cli
    # [[OTHER]]
    flavours
    spotify-tui
    teamviewer
    virt-viewer
    virtmanager
    # [[PHD]]
    jupyter
    libreoffice
    mysql80
    zathura
    zettlr
    zotero
    # [[PROGRAMMING]]
    cargo
    gcc
    jdk
    jetbrains.jdk
    lua
    powershell
    python3
    (pkgs.callPackage ./rstudio.nix { })
    rustc
    # [[SOCIAL]]
    discord
    signal-desktop
    teams
    whatsapp-for-linux
    # [[Terminal]]
    alacritty
    starship
    # [[TOOLS]]
    alsa-utils
    apparix
    bat
    bc
    brightnessctl
    calc
    check-uptime
    cryptsetup
    curl
    delta
    dos2unix
    feh
    flameshot
    fzf
    git
    guvcview
    gzip
    htop
    imagemagick
    imv
    iotop
    lsd
    jq
    mpv
    multilockscreen
    mdbook
    neofetch
    onefetch
    pavucontrol
    peek
    pkgs.nodePackages.npm
    psmisc
    pulseaudioFull
    qt5.qtgraphicaleffects
    qt5.qtmultimedia
    qt5.qtquickcontrols
    qt5.qtquickcontrols2
    rofi
    scrot
    spotify
    stow
    tree
    vivid
    usbutils
    unzip
    volumeicon
    wget
    wf-recorder
    xclip
    zathura
    zettlr
    zip
    # [[NIXOS-TOOLS]]
    nixpkgs-fmt
    nix-prefetch-github
    nix-output-monitor
  ];
}
