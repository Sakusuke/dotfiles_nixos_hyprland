{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Nix
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Kernel Modules
  ## all three lines for DSLR Webcam with Gphoto2
  boot.extraModulePackages = with config.boot.kernelPackages;
    [ v4l2loopback.out ];
  boot.kernelModules = [ "v4l2loopback" ];
  boot.extraModprobeConfig = '' options v4l2loopback exclusive_caps=1 card_label="Virtual Camera" '';

  # Enable networking and bluetooth
  networking.networkmanager.enable = true;
  networking.hostName = "lap"; # Define your hostname.
  networking.nameservers = [ "192.168.2.50" ];
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  # Hosts
  #networking.extraHosts = ''
  #  192.168.2.50 jellyfin.optiplex.box
  #'';

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
  #sound.enable = true; deprecated on nix
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
  };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "de";
    variant = "";
  };
  ## fcitx5
    # Configure fcitx5
  i18n.inputMethod = {
    enabled = "fcitx5";
    fcitx5.addons = with pkgs; [
        fcitx5-mozc
        fcitx5-gtk
    ];
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.lap = {
    isNormalUser = true;
    description = "Lap";
    extraGroups = [ "networkmanager" "wheel" "samba" "brigtness" "scanner" "lp" "adbusers" "davfs2" ];
    packages = with pkgs; [];
  };
  users.defaultUserShell = pkgs.zsh;
  security.sudo.wheelNeedsPassword = false;
  services.getty.autologinUser = "lap";

  # List packages installed in system profile. To search, run:
  nixpkgs.config = {
    allowUnfree = true;
    #packageOverrides = pkgs: {
    #unstable = import (fetchTarball "https://github.com/NixOS/nixpkgs/archive/nixos-unstable.tar.gz") {};
    #};
  };
  
  environment.systemPackages = with pkgs; [
    vim 
    wget
    git
    yadm
    gh
    dig
    pcmanfm
    firefox
    #floorp
    mpv
    digikam
    discord
    jellyfin-mpv-shim
    jellyfin-media-player
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
    rofi-wayland
    brightnessctl
    pamixer
    mate.engrampa
    skanlite
    haskellPackages.youtube
    tauon
    #gpicview deprecated on nix
    sshfs
    flatpak
    cargo
    davfs2 # `usermod -aG davfs2 <username>` or add group further down
    # file
    p7zip
    vimv

    # webcam
    gphoto2
    ffmpeg
    udiskie
    krita
    sxiv

    # games
    wineWowPackages.waylandFull
    winetricks
    lutris

    # bitwarden
    bitwarden
    bitwarden-cli
    #unstable.goldwarden

    # Office
    libreoffice-qt
    hunspell
    hunspellDicts.uk_UA

    # insecure
    obsidian
    viber
    lutris
  ];

  # shitty thing for [ obsidian viber ]
  nixpkgs.config.permittedInsecurePackages = [ "electron-25.9.0" "openssl-1.1.1w" ];


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

  # Printers and scanner (add sane and lp group to user)
  services.printing.enable = true;
  hardware.sane.enable = true;

  # List services that you want to enable:
  programs.zsh.enable = true;
  services.openssh.enable = true;
  programs.steam.enable = true;
  security.polkit.enable = true;
  services.udisks2.enable = true;
  services.gvfs.enable = true;
  programs.udevil.enable = true;
  services.flatpak.enable = true;
  programs.adb.enable = true;
  #hardware.xone.enable = true;
  programs.java = { enable = true; }; #package = pkgs.oraclejre8; }; # Java for MtG forge

  # Fonts
  fonts.packages = with pkgs; [
    #(nerdfonts.override { fonts = [ "Iosevka" ]; })
    nerd-fonts.iosevka
    noto-fonts-cjk-sans
    source-han-sans
    corefonts vistafonts #windows fonts
  ];

  system.stateVersion = "23.11"; # Did you read the comment?
}
