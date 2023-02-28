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
    lua
    powershell
    python3
    (pkgs.callPackage ./rstudio.nix { })
    rustc
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
    file
    flameshot
    fzf
    git
    guvcview
    htop
    imagemagick
    imv
    iotop
    jq
    kanshi
    lsd
    mdbook
    mpv
    multilockscreen
    neofetch
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
    sshpass
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
    zellij
    zip
    # [[NIXOS-TOOLS]]
    nixpkgs-fmt
    nix-output-monitor
    nix-prefetch-github
  ];
}
