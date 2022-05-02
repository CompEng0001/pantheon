# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports = [
     # Include the results of the hardware scan.
     ./hardware-configuration.nix
#    ./vim-configuration.nix
  ];

  boot = {
      loader.systemd-boot.enable = true;
      loader.efi.canTouchEfiVariables = true;
     # kernelPackages = pkgs.linuxPackages_lastest;
  };
  # Use the GRUB 2 boot loader.
  #boot.loader.grub.enable = true;
  #boot.loader.grub.version = 2;
  #boot.loader.grub.device = "/dev/nvme0n1p3"; # or "nodev" for efi only

  time.timeZone = "Europe/London";
    networking ={
		   hostName = "Vakare"; # Define your hostname.  Lithuanian Goddess of the evening star
		   useDHCP = false;
		   interfaces.wlan0.useDHCP = true;
		   firewall.enable = false;
		   wireless.iwd.enable = true;
		   networkmanager.wifi.backend = "iwd";
  };

  i18n.defaultLocale = "en_GB.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "uk";
  };

  services.udev.extraRules = ''
    ACTION=="add", 
    SUBSYSTEM=="backlight", 
    KERNEL=="intel_backlight", 
    MODE="0666", 
    RUN+="${pkgs.coreutils}/bin/chmod a+w /sys/class/backlight/intel_backlight/brightness"
    '';

  services.xserver = {
    enable = true;
    layout = "gb";
    libinput = {
      enable = true;
      touchpad.naturalScrolling = true ;
      touchpad.middleEmulation = true; 
      touchpad.tapping = true; 
    };
  
  displayManager ={
    defaultSession = "none+i3"; 
    #lightdm.enable;
    sddm.enable = true; 
    sddm.theme = "${(pkgs.fetchFromGitHub {
        owner = "3ximus";
        repo = "aerial-sddm-theme";
        rev = "6beb74994935743e0fae9413160d3ee936d4bf2";
        sha256 = "089r3wxhz2khhmbflvscbnk7mllnv2w04gc6lfzw7zgp36rmhxyp";
    })}";
  };

  windowManager.i3 = {
     enable = true;
     package = pkgs.i3-gaps;
     extraPackages = with pkgs; [
	betterlockscreen i3-gaps i3lock i3lock-color polybar];
     };
  };
 
  nixpkgs.config =  {
 	packageOverrides = pkgs: rec {
	  polybar = pkgs.polybar.override {
				i3Support = true;
			};
		};
  };
  services.pipewire= {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
    socketActivation = true;
  };

  users.users.seb = {
    isNormalUser = true;
    extraGroups = [ "wheel" "sudo" "video" "audio" "netdev" "networkmanager" ]; # Enable ‘sudo’ for the user.
  };
  
  systemd.tmpfiles.rules = [
	"d /mnt/ 0755 root root"
	"d /mnt/usb/ 0755 root root"
	"d /home/seb/Music 0755 seb users"
	"d /home/seb/Git 0755 seb users"
	];

  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowUnsupportedSystem = true;

  environment.systemPackages = with pkgs; [
  #[EDITORS]
	vim nano vscodium
  #[INTERNET]
	brave speedtest-cli nmap
  #[OTHER]
	spotify
	flavours
	teamviewer
  #[PHD]
	jupyter
	zettlr
  #[PROGRAMMING]
	cargo rustc lua powershell
	python3
	python39Packages.python
	python39Packages.numpy
	python39Packages.matplotlib
	python39Packages.pip
	(let
	  my-python-packages = python-packages: with python-packages; [
 	  	pandas
   		requests
			scipy
			matplotlib
			seaborn
			scikit-learn
			plotly
			pyperclip
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
	brightnessctl
  curl
	dos2unix
	feh
	flameshot
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
	qt5.qtquickcontrols
	qt5.qtquickcontrols2	
	qt5.qtgraphicaleffects
	qt5.qtmultimedia
	rofi
	scrot
	sddm
	stow
	wget
	xclip
	#xorg.xbacklight
	zettlr
  #[NIXOS-TOOLS]
	nix-prefetch-github
  ];

  programs ={
		bash = {
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
		nano = {
	    syntaxHighlight = true;
	    nanorc = ''
				set autoindent
				set nowrap
				set tabsize 2
				set linenumbers
				set nonewlines
				'';
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