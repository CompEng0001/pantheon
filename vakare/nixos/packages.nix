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
    android-studio
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
    lua
    powershell
    python3
    (pkgs.callPackage ./rstudio.nix { })
    rustc
    jdk
    # [[SOCIAL]]
    discord
    signal-desktop
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
    htop
    imagemagick
    imv
    iotop
    kanshi
    jq
    kanshi
    lsd
    mdbook
    mpv
    mosquitto
    multilockscreen
    neofetch
    netcat
    onefetch
    pavucontrol
    peek
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
    unzip
    usbutils
    v8
    vivid
    volumeicon
    wf-recorder
    wget
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
