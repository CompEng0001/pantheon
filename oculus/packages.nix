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
      "openssl-1.1.1u"
      # error: Package ‘openssl-1.1.1u’ in /nix/store/hsv0sv3ryif6k7zwqjlrngrdhwqdk9gz-nixos-23.05/nixos/pkgs/development/libraries/openssl/default.nix:210 is marked as insecure, refusing to evaluate.
      # OpenSSL 1.1 is reaching its end of life on 2023/09/11 and cannot be supported through the NixOS 23.05 release cycle. https://www.openssl.org/blog/blog/2023/03/28/1.1.1-EOL/
    ];
  };
  environment.systemPackages = with pkgs; [

    # [[EDITORS]]
    android-studio
    android-tools
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
    virt-manager
    vmware-horizon-client
    # [[PHD]]
    jupyter
    libreoffice
    mysql80
    zathura
    zettlr
    # zotero # https://github.com/NixOS/nixpkgs/pull/262808 insecure CVE vulnerability
    # [[PROGRAMMING]]
    cargo
    gcc
    clang-tools_9
    bear
    kotlin
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
    git-lfs
    globalprotect-openconnect
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
    mdbook
    mako
    mpv
    multilockscreen
    neofetch
    nodejs
    ntfs3g
    pavucontrol
    playerctl
    peek
    playerctl
    polkit
    polkit_gnome
    psmisc
    pulseaudioFull
    ptouch-print
    qemu_full
    qt5.qtgraphicaleffects
    qt5.qtmultimedia
    qt5.qtquickcontrols
    qt5.qtquickcontrols2
    qt5.qtwayland
    qt6.full
    restream
    rofi
    rsync
    scrot
    sshpass
    spotify
    stow
    swayfx
    tree
    unzip
    usbutils
    v8
    vivid
    virt-manager
    vlc
    volumeicon
    yarn
    wf-recorder
    wget
    wineWowPackages.waylandFull
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
