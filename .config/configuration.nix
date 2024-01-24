{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Enable networking and bluetooth
  networking.networkmanager.enable = true;
  networking.hostName = "nixos"; # Define your hostname.
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  # Kernel
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Set your time zone and Locale
  time.timeZone = "Europe/Berlin";
  services.ntp.enable = true;

  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "de_DE.UTF-8";
    LC_IDENTIFICATION = "de_DE.UTF-8";
    LC_MEASUREMENT = "de_DE.UTF-8";
    LC_MONETARY = "de_DE.UTF-8";
    LC_NAME = "de_DE.UTF-8";
    LC_NUMERIC = "de_DE.UTF-8";
    LC_PAPER = "de_DE.UTF-8";
    LC_TELEPHONE = "de_DE.UTF-8";
    LC_TIME = "de_DE.UTF-8";
  };

  # Graphic Enviorement
  programs.hyprland.enable = true;
  
  # Audio
  security.rtkit.enable = true;
  sound.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
  };

  # Configure keymap in X11
  services.xserver = {
    layout = "us";
    xkbVariant = "";
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.lap = {
    isNormalUser = true;
    description = "Lap";
    extraGroups = [ "networkmanager" "wheel" "samba" "brigtness" ];
    packages = with pkgs; [];
  };
  users.defaultUserShell = pkgs.zsh;
  security.sudo.wheelNeedsPassword = false;
  services.getty.autologinUser = "lap";

  # List packages installed in system profile. To search, run:
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    vim 
    wget
    git
    yadm
    gh
    pcmanfm
    firefox
    mpv
    calibre
    pavucontrol
    foot
    neofetch
    magic-wormhole
    waybar
    hyprpaper
    fd
    ncdu
    htop
    killall
    jq
    obsidian
    rofi-wayland
    brightnessctl
    pamixer
    mate.engrampa
    cargo
    #rust
  ];

  # battery services
   services.upower.enable = true;
   services.auto-cpufreq = {
     enable = true;
     settings = {
       battery = {
         governor = "powersave";
         turbo = "never";
       };
       charger = {
         governor = "performance";
         turbo = "auto";
       };
     };
   };

  # Host Samba share
  services.samba-wsdd.enable = true;
  services.samba = {
    enable = true;
    securityType = "user";
    shares.global = {
      "server min protocol" = "SMB2_02";
    };
    shares.NIXLAP13 = {
      path = "/home/lap"; #BAD
      writeable = "yes";
      browseable = "yes";
      "read only" = "no";
      "guest ok" = "yes";
    };
  };

  # List services that you want to enable:
   programs.zsh.enable = true;
   services.openssh.enable = true;
   programs.steam.enable = true;

  # Fonts
  fonts.packages = with pkgs; [
    (nerdfonts.override { fonts = [ "Iosevka" ]; })
    noto-fonts-cjk
    source-han-sans
  ];

  system.stateVersion = "23.11"; # Did you read the comment?
}
