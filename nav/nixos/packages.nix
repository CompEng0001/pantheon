# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ pkgs, ... }:
{  
  environment.systemPackages = with pkgs; [

    #[EDITORS]
    vim
    nano
    vscodium
    arduino
    #[INTERNET]
    brave
    speedtest-cli
    nmap
    #[OTHER]
    spotify-tui
    flavours
    teamviewer
    #[PHD]
    jupyter
    zettlr
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
    bc
    brightnessctl
    calc
    curl
    dos2unix
    feh
    flameshot
		fwupd
    git
    htop
    iotop
    imagemagick
    iwd
    lsd
    multilockscreen
    neofetch
    peek
    psmisc
		powertop
    pulseaudioFull
    qt5.qtquickcontrols
    qt5.qtquickcontrols2
    qt5.qtgraphicaleffects
    qt5.qtmultimedia
    rofi
    scrot
    spotify
    stow
    wget
    xclip
    zathura
    zettlr
    #[NIXOS-TOOLS]
    nix-prefetch-github
  ];
}
