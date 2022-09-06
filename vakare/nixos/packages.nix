# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ pkgs, ... }: {
  nixpkgs.config = {

    virtualbox = { host.enableExtensionPack = true; };

    mpv = { youtubeSupport = true; };
  };

  nixpkgs.config.permittedInsecurePackages = [
    "python3.9-mistune-0.8.4"
  ];

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
    libreoffice
    jupyter
    mysql80
    zathura
    zettlr
    zotero
    #[PROGRAMMING]
    cargo
    gcc
    lua
    powershell
    python3
    (let
      RStudio-with-my-packages = rstudioWrapper.override
      { packages = with rPackages; 
      [ 
        janitor    # https://www.rdocumentation.org/packages/janitor/versions/2.1.0
        knitr      # https://www.rdocumentation.org/packages/knitr/versions/1.39
        lubridate
        mlr        # https://www.rdocumentation.org/packages/mlr/versions/2.19.0
        mlr3       # https://www.rdocumentation.org/packages/mlr3/versions/0.14.0
        rjson      # https://www.rdocumentation.org/packages/rjson/versions/0.2.21
        tidyjson   # https://www.rdocumentation.org/packages/tidyjson/versions/0.3.1
        tidyverse  # https://www.rdocumentation.org/packages/tidyverse/versions/1.3.2
        tidymodels # https://www.rdocumentation.org/packages/tidymodels/versions/1.0.0
        xmlconvert # https://www.rdocumentation.org/packages/xmlconvert/versions/0.1.2
        xtable     # https://www.rdocumentation.org/packages/xtable/versions/1.8-4
      ];
    };
    in
    RStudio-with-my-packages)    
    rustc
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
    fzf
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
    volumeicon
    wget
    xclip
    zathura
    zettlr
    #[NIXOS-TOOLS]
    nix-prefetch-github
  ];
}
