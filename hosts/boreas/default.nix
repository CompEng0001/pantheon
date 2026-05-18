{ config, pkgs, ... }:

{

  time.timeZone = "Europe/London";
  networking = {
    hostName = "boreas";
    useDHCP = false;
    interfaces.eno1.useDHCP = true;
    firewall.enable = false;
  };
  networking.networkmanager.enable = true;

  i18n.defaultLocale = "en_GB.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "uk";
  };

  nix.settings = {
    sandbox = true;
    cores = 0;
    auto-optimise-store = true;
    experimental-features = [ "nix-command" "flakes" ];
  };

  users.users.dev = {
    isNormalUser = true;
    extraGroups = [ "wheel" "libvirtd" "video" "audio" "netdev" "pulse" "pulse-access" "adbusers" ];
    uid = 1000;
    shell = "${pkgs.zsh}/bin/zsh";
  };

  systemd.tmpfiles.rules = [
    "d /mnt/ 0755 root root"
    "d /home/dev/Music 0755 dev users"
    "d /home/dev/Git 0755 dev users"
    "d /home/dev/Documents 0755 dev users"
  ];

  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowUnsupportedSystem = true;

  programs = {
    zsh = {
      enable = true;
      promptInit = ''
        eval "$(${pkgs.starship}/bin/starship init zsh)"
        ${pkgs.any-nix-shell}/bin/any-nix-shell zsh --info-right | source /dev/stdin

	# Custom Aliases
        if [ -f ~/.config/zsh/aliases.zsh ]; then
              source ~/.config/zsh/aliases.zsh
        fi

        # Custom ANSI term highlighters
        if [ -f ~/.config/zsh/termcap.zsh ]; then
              source ~/.config/zsh/aliases.zsh
        fi
      '';
      interactiveShellInit = ''
        zstyle ':completion:*' menu select
        source ${pkgs.fzf}/share/fzf/key-bindings.zsh
      '';
      autosuggestions.enable = true;
      setOptions = [
        "auto_cd"
        "auto_pushd"
        "correct"
        "hist_fcntl_lock"
        "hist_ignore_dups"
        "hist_no_store"
        "hist_reduce_blanks"
      ];
    };
  };

  environment = {
    sessionVariables = {
      XDG_SESSION_TYPE = "wayland";
      XDG_CURRENT_DESKTOP = "wayland";
      MOZ_ENABLE_WAYLAND = "1";
      MOZ_USE_XINPUT2 = "1";
      SDL_VIDEODRIVER = "wayland";
      QT_QPA_PLATFORM = "wayland-egl";
      QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
      XKB_DEFAULT_LAYOUT = "gb";
      NIXPKGS_ALLOW_UNFREE = "1";
    };
    shellInit = ''
      export GPG_AGENT_INFO=$HOME/.gnupg/S.gpg-agent
      export LIBVIRT_DEFAULT_URI=qemu:///system
      export LS_COLORS="$(vivid generate snazzy)"
      export EDITOR='vim'
    '';
    shells = [ pkgs.zsh ];
  };

  xdg.portal = {
    enable = true;
  };

  fonts = {
    fontconfig = {
      enable = true;
      useEmbeddedBitmaps = true;
      localConf = ''
        <?xml version='1.0'?>
        <!DOCTYPE fontconfig SYSTEM 'urn:fontconfig:fonts.dtd'>
        <fontconfig>
        <alias binding="same">
        <family>MxPlus IBM VGA 8x16</family>
        <prefer>
          <family>MxPlus IBM VGA 8x16</family>
          <family>DejaVuSansM Nerd Font</family>
        </prefer>
        </alias>
        </fontconfig>
      '';
    };
    enableGhostscriptFonts = true;
    packages = with pkgs; [
      unscii
      corefonts
      cozette
      google-fonts
      junicode
      siji
      tt2020
      ultimate-oldschool-pc-font-pack
      unifont
      vista-fonts
    ] ++ lib.filter lib.isDerivation (lib.attrValues nerd-fonts);
  };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  system.stateVersion = "25.11"; # Did you read the comment?
}
