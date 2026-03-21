# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ pkgs, ... }: {

  environment.systemPackages = with pkgs; [
    # [[SYSTEM INVESTIGATION TOOLS]]
    hw-probe
    dmidecode
    i2c-tools
    mcelog
    acpica-tools
    mesa-demos
    nvme-cli

    # [[EDITORS]]
    android-studio
    android-tools
    arduino
    arduino-core
    arduino-cli
    #(pkgs.callPackage ./vim.nix { })
    vscode
    jetbrains.idea-oss

    # [[INTERNET]]
    brave
    firefox-devedition
    nmap
    speedtest-cli
    # [[OTHER]]
    flavours
    teamviewer
    virt-viewer
    virt-manager
    #omissa-horizon-client

# [[PHD]]
    jupyter
    libreoffice
    mysql80
    zathura
    zettlr
    # zotero # https://github.com/NixOS/nixpkgs/pull/262808 insecure CVE vulnerability
    # [[PROGRAMMING]]
    bats
    cargo
    gcc
    #clang-tools_9
    bear
    kotlin
    lua
    powershell
    python3
    #(pkgs.callPackage ./rstudio.nix { })
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
    cryptsetup
    curl
    delta
    dos2unix
    fastfetch
    feh
    ffmpeg
    file
    flameshot
    fzf
    gammastep
    geoclue2
    git
    git-lfs
    openconnect
    guvcview
    htop
    imagemagick
    imv
    inkscape
    iotop
    jdk
    jq
    kanshi
    lsd
    lutris
    lz4
    mako
    mdbook
    mpv
    multilockscreen    
    nodejs
    nodejs.libv8
    ntfs3g
    pavucontrol
    peek
    playerctl
    polkit
    polkit_gnome
    psmisc
    ptouch-print
    pulseaudioFull
    qt5.qtgraphicaleffects
    qt5.qtmultimedia
    qt5.qtquickcontrols
    qt5.qtquickcontrols2
    qt5.qtwayland
    qt6.full
    restream
    rofi
    rsync
    satty
    scrot
    slurp
    spotify
    sshpass
    stow
    swayfx
    swaybg
    swayidle
    swaylock-effects
    swww
    tree
    unzip
    usbutils
    virt-manager
    vivid
    vlc
    volumeicon
    wl-clipboard
    wl-screenrec
    wlr-randr
    wf-recorder
    wget
    yarn
    zathura
    zellij
    zettlr
    zip
    # [[NIXOS-TOOLS]]
    nixpkgs-fmt
    nix-output-monitor
    nix-prefetch-github
  ];
}
