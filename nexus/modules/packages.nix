# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ pkgs, ... }: {

  environment.systemPackages = with pkgs; [
    # [[SYSTEM INVESTIGATION TOOLS]]
    hw-probe                    # probe hardware and upload/report system details
    dmidecode                   # inspect BIOS, motherboard, and hardware metadata
    i2c-tools                   # utilities for inspecting and interacting with I2C devices
    mcelog                      # read and decode CPU machine check errors
    acpica-tools                # ACPI inspection and debugging tools
    mesa-demos                  # OpenGL and Mesa demonstration/test programs
    nvme-cli                    # manage and inspect NVMe SSDs

    # [[EDITORS]]
    arduino                     # Arduino IDE for microcontroller development
    arduino-core                # core Arduino tooling and platform support
    arduino-cli                 # command-line interface for Arduino projects
    (pkgs.callPackage ./vim.nix { }) # custom Vim package from local nix file
    vscode                      # Visual Studio Code editor
    jetbrains.idea-oss          # IntelliJ IDEA Community Edition

    # [[INTERNET]]
    brave                       # Chromium-based web browser
    firefox-devedition          # Firefox Developer Edition browser
    nmap                        # network scanner and service discovery tool
    speedtest-cli               # command-line internet speed test

    # [[OTHER]]
    flavours                    # theme and colour scheme manager
    teamviewer                  # remote desktop and support software
    virt-viewer                 # viewer for virtual machine consoles
    virt-manager                # graphical virtual machine manager

    # [[PHD]]
    jupyter                     # notebooks for research, experiments, and teaching
    libreoffice                 # office suite for documents, spreadsheets, and presentations
    mysql80                     # MySQL 8.0 database server and client tools
    zathura                     # lightweight keyboard-driven PDF/document viewer
    zettlr                      # markdown-based academic writing and note-taking tool
    # zotero                    # reference manager; currently commented due to insecure CVE issue

    # [[PROGRAMMING]]
    bats                        # Bash automated testing framework
    cargo                       # Rust package manager and build tool
    gcc                         # GNU C/C++ compiler toolchain
    clang-tools                 # Clang-based development and analysis tools
    bear                        # generate compilation database for C/C++ tooling
    kotlin                      # Kotlin compiler and tooling
    lua                         # Lua programming language interpreter
    powershell                  # PowerShell shell and scripting environment
    python3                     # Python 3 interpreter
    #(pkgs.callPackage ./rstudio.nix { }) # custom RStudio package from local nix file
    rustc                       # Rust compiler

    # [[SOCIAL]]
    discord                     # chat, voice, and community platform
    signal-desktop              # desktop client for Signal messaging

    # [[Terminal]]
    alacritty                   # GPU-accelerated terminal emulator
    starship                    # cross-shell prompt customisation tool

    # [[TOOLS]]
    adwaita-icon-theme          # GNOME default icon theme
    alsa-utils                  # ALSA audio utilities and mixer tools
    apparix                     # fast directory bookmarking and jumping utility
    aspell                      # spell checker
    aspellDicts.en              # English dictionary
    bat                         # cat clone with syntax highlighting
    bc                          # arbitrary precision calculator language
    brightnessctl               # control screen backlight brightness
    broot                       # interactive terminal file tree navigator
    calc                        # command-line calculator
    nagiosPlugins.check_uptime  # check system uptime for monitoring
    nagiosPlugins.check_ups_health # check UPS status and health for monitoring
    cryptsetup                  # manage encrypted disks with LUKS/dm-crypt
    csvlens                     # CSV file explorer (TUI)
    curl                        # transfer data from URLs
    delta                       # enhanced diff viewer for Git and terminal output
    dos2unix                    # convert line endings between DOS and Unix formats
    fastfetch                   # display system information in terminal
    feh                         # lightweight image viewer
    file                        # identify file types
    flac                        # FLAC audio tools
    fuzzel                      # Wayland application launcher
    fzf                         # fuzzy finder for terminal workflows
    gammastep                   # adjust screen colour temperature
    geoclue2                    # geolocation service used by desktop apps
    git                         # distributed version control system
    git-lfs                     # Git Large File Storage support
    gfold                       # tree-style Git repository status viewer
    openconnect                 # VPN client for Cisco/AnyConnect compatible VPNs
    guvcview                    # webcam viewer and capture tool
    htop                        # interactive process viewer
    imagemagick                 # image conversion and manipulation tools
    imv                         # lightweight image viewer for X11/Wayland
    inkscape                    # vector graphics editor
    iotop                       # monitor per-process disk I/O usage
    jdk                         # Java Development Kit
    jq                          # command-line JSON processor
    kanshi                      # dynamic output configuration for Wayland
    libnotify                   # desktop notification library and tools
    lsd                         # modern ls replacement with icons and colours
    lz4                         # fast compression utility
    magic-wormhole-rs           # secure file transfer between devices
    mako                        # lightweight Wayland notification daemon
    man-pages                   # Linux manual pages
    man-pages-posix             # POSIX manual pages
    mdbook                      # create books and documentation from Markdown
    mpv                         # media player
    multilockscreen             # multiple lockscreen helper/tooli
    ncmpcpp                     # MPD music client
    nodejs                      # Node.js JavaScript runtime
    ntfs3g                      # NTFS filesystem support
    openssh                     # SSH client and server tools
    pavucontrol                 # PulseAudio volume control GUI
    peek                        # animated screen recorder for short captures
    playerctl                   # control media players from command line
    polkit                      # privilege management framework
    polkit_gnome                # GNOME agent for polkit authentication prompts
    procs                       # modern replacement for ps
    psmisc                      # miscellaneous process management tools
    ptouch-print                # print labels to Brother P-touch devices
    pulseaudioFull              # full PulseAudio sound server package
    #qemu_full                  # full QEMU virtualisation package
    restream                    # stream forwarding/restreaming tool
    ripgrep                     # fast recursive search (grep alt
    rofi                        # application launcher and dmenu replacement
    ripgrep                     # fast recursive text search tool
    rsync                       # fast local/remote file synchronisation
    satty                       # screenshot annotation tool for Wayland
    slurp                       # region selection tool for Wayland
    sox                         # audio processing toolkit
    spotify                     # Spotify desktop client
    sshpass                     # non-interactive SSH password helper
    stow                        # symlink-based dotfile manager
    swaybg                      # wallpaper tool for Wayland compositors
    swayidle                    # idle management daemon for Wayland
    swaylock-effects            # screen locker with visual effects
    swayfx                      # enhanced Sway compositor fork
    tree                        # display directories as a tree
    unzip                       # extract ZIP archives
    usbutils                    # tools such as lsusb for USB inspection
    vale                        # prose linting tool
    vhs                         # terminal GIF/demo recorder
    vivid                       # generate LS_COLORS themes
    vlc                         # media player
    volumeicon                  # system tray volume control icon
    waybar                      # highly configurable Wayland status bar
    wl-clipboard                # clipboard utilities for Wayland
    wl-mirror                   # mirror Wayland outputs/windows
    wf-recorder                 # screen recorder for Wayland
    wget                        # download files from the web
    xwayland-satellite          # run Xwayland rootlessly alongside Wayland compositors
    yarn                        # JavaScript package manager
    yt-dlp                      # download videos (YouTube etc.)
    zellij                      # terminal workspace and multiplexer
    zip                         # create ZIP archives

    # [[NIXOS-TOOLS]]
    nix-update                  # update nix package versions
    nixfmt                      # Nix formatter (alt)
    nixpkgs-fmt                 # formatter for Nix expressions
    nix-output-monitor          # improved build output for Nix commands
    nix-prefetch-github         # fetch GitHub source hashes for Nix packaging
    nix-tree                    # inspect Nix dependency trees
  ];
}
