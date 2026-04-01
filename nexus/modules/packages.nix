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
    (pkgs.callPackage ./vim.nix { })
    android-studio
    android-tools
    arduino
    arduino-cli
    arduino-core
    jetbrains.idea-oss
    libreoffice
    vim
    vscode

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

    # [[PHD]]
    jupyter
    zathura
    zettlr
    # zotero # https://github.com/NixOS/nixpkgs/pull/262808 insecure CVE vulnerability
    
    # [[PROGRAMMING]]
    bats
    cargo
    gcc
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
    adwaita-icon-theme
    alsa-utils
    apparix
    bat
    bc
    broot
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
    grim
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
    ntfs3g
    pavucontrol
    peek
    peep
    playerctl
    polkit
    polkit_gnome
    procs
    psmisc
    ptouch-print
    pulseaudioFull
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
    waybar	    
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
    nix-tree
    nixpkgs-fmt
    nix-output-monitor
    nix-prefetch-github
  ];
}
