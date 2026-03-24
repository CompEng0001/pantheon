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
    clang-tools
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
    ntfs3g
    pavucontrol
    peek
    playerctl
    polkit
    polkit_gnome
    psmisc
    ptouch-print
    pulseaudioFull
    #qemu_full
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
    tree
    unzip
    usbutils
    virt-manager
    vivid
    vlc
    volumeicon
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
