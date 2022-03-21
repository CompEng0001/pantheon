# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
#    ./vim-configuration.nix
  ];

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.device = "/dev/sda"; # or "nodev" for efi only

  time.timeZone = "Europe/London";

  networking.hostName = "nixos"; # Define your hostname.
  networking.useDHCP = false;
  networking.interfaces.enp0s3.useDHCP = true;
  networking.firewall.enable = false;

  i18n.defaultLocale = "en_GB.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "uk";
  };

  services.xserver = {
    enable = true;
    layout = "gb";
    displayManager.defaultSession = "none+i3";
    displayManager.lightdm = {
      enable = true;
    };
    windowManager.i3 = {
      enable = true;
      package = pkgs.i3-gaps;
      extraPackages = with pkgs; [
	betterlockscreen i3-gaps i3lock i3lock-color i3status-rust polybar ];
    };
  };

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
    socketActivation = true;
  };

  users.users.seb = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
  };

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
       #[EDITORS]
	vim nano vscodium
       #[INTERNET]
	brave speedtest-cli nmap
       #[OTHER]
	spotify
	flavours
       #[PHD]
	jupyter
	zettlr
       #[PROGRAMMING]
	cargo rustc lua powershell
	python3
	python38Packages.python
	python38Packages.numpy
	python38Packages.matplotlib
	python38Packages.pip
	(let
	  my-python-packages = python-packages: with python-packages; [
 	  	pandas
    		requests
		scipy
		matplotlib
		seaborn
		scikit-learn
		plotly
  	];
  	python-with-my-packages = python3.withPackages my-python-packages;
	in
	python-with-my-packages)
       #[SOCIAL]
	discord signal-desktop teams
       #[Terminal]
	alacritty
	starship
       #[TOOLS]
	apparix
	bc
	curl
	dos2unix
	feh
	flameshot
	git
	htop
	iotop
	imagemagick
	lsd
	multilockscreen
	neofetch
	rofi
	scrot
	stow
	wget
	zettlr
  ];

  programs.bash = {
    enableCompletion = true;
    enableLsColors = true;
    promptInit = ''
      eval "$(${pkgs.starship}/bin/starship init bash)"
    '';
    shellAliases = {
      config = "sudo nano /etc/nixos/configuration.nix";
      ls = "lsd";	
      ll = "lsd -l";
       l = "lsd -lah";
    };
  };

  fonts = {
    fontconfig = {
      enable = true;
      useEmbeddedBitmaps = true;
    };
    enableGhostscriptFonts= true;
    fonts = with pkgs; [
      clearlyU
      fixedsys-excelsior
      cm_unicode
      cozette
      dosemu_fonts
      freefont_ttf
      google-fonts
      junicode
      nerdfonts
    ] ++ lib.filter lib.isDerivation (lib.attrValues lohit-fonts);
  };

  system.stateVersion = "21.11";
}

