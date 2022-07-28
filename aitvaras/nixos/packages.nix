# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ pkgs, ... }: {
  nixpkgs.config = {

    virtualbox = { host.enableExtensionPack = true; };

    mpv = { youtubeSupport = true; };
  };

  environment.systemPackages = with pkgs; [

    #[EDITORS]
    vim
    nano
    vscode
    arduino
    #[INTERNET]
    brave
    chromium
    speedtest-cli
    nmap
    #[OTHER]
    spotify-tui
    flavours
    teamviewer
    virt-viewer
    virtmanager
    #[PHD]
    jupyter
    mysql80
    zathura
    zettlr
    zotero
    #[PROGRAMMING]
    cargo
    rustc
    lua
    powershell
    python3
    gcc
    #[SOCIAL]
    discord
    signal-desktop
    teams
    #[Terminal]
    alacritty
    starship
    #[TOOLS]
    alsa-utils
    apparix
    bat
    bc
    brightnessctl
    calc
    check-uptime
    cryptsetup
    curl
    dos2unix
    feh
    flameshot
    git
    guvcview
    htop
    iotop
    imagemagick
    lsd
    multilockscreen
    mpv
    neofetch
    pavucontrol
    peek
    psmisc
    pulseaudioFull
    qt5.qtquickcontrols
    qt5.qtquickcontrols2
    qt5.qtgraphicaleffects
    qt5.qtmultimedia
    rofi
    scrot
    spotify
    stow
    usbutils
    wget
    xclip
    zathura
    zettlr
    #[NIXOS-TOOLS]
    nix-prefetch-github
  ];
}
