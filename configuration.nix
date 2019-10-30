# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs,... }:

{
  imports =
    [
      ./hardware-configuration.nix 
      ./zsh.nix
    ];

  # Boot settings
  boot.plymouth.enable = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.cleanTmpDir = true;
  boot.loader = {
    efi = {
      canTouchEfiVariables = true;
    };
    systemd-boot.enable = false;
    grub = {
      enable = true;
      version = 2;
      enableCryptodisk = true;
      useOSProber = true;
      device = "nodev";
      efiSupport = true;
    };
  };

  networking.hostName = "cguertz"; # Define your hostname.
  networking.networkmanager.enable = true;
  
  # Android license acceptation

  # Automatic GC of nix files
  nix.gc = {
    automatic = true;
    dates = "daily";
    options = "--delete-older-than 10d";
  };

  #services.xserver.monitorSection = ''
  #  DisplaySize 406 228
  #'';

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.wlp59s0.useDHCP = true;

  # Display drivers.  
  hardware.bumblebee.enable = true;
  #services.xserver.videoDrivers = [ "nvidia" ];
  #hardware.nvidia.optimus_prime.enable = true;
  # Bus ID of the NVIDIA GPU. You can find it using lspci
  #hardware.nvidia.optimus_prime.nvidiaBusId = "PCI:1:0:0";
  # Bus ID of the Intel GPU. You can find it using lspci
  #hardware.nvidia.optimus_prime.intelBusId = "PCI:0:2:0";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n = {
     consoleFont = "Hack Regular";
     consoleKeyMap = "us";
     defaultLocale = "en_CA.UTF-8";
  };

  # Set your time zone.
  time.timeZone = "America/Toronto";

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.android_sdk.accept_license = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    wget curl vim telnet neofetch

    git tree cmake gcc tilda tig zip unzip

    firefox libreoffice thunderbird heroku slack

    docker docker-compose nodejs

    kubectl kubernetes-helm minikube terraform

    vscode spotify postman google-chrome

    mongodb-compass redshift watchman openjdk 

    adapta-kde-theme papirus-icon-theme caffeine-ng

    gwenview gimp okular ark vlc kdeApplications.spectacle

    kdeApplications.kcalc gnumake androidsdk_9_0
  ];

  # Fonts
  fonts.fonts = with pkgs; [
    fira-code
    fira-code-symbols
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = { enable = true; enableSSHSupport = true; };

  # Virtualisation.
  virtualisation.virtualbox.host.enable = true;
  # virtualisation.virtualbox.guest.enable = true; -> Causes problems.
  virtualisation.docker.enable = true;
  # virtualisation.libvirtd.enable = true; -> Causes problems.
  

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = false;
  networking.firewall.allowPing = false;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;
  hardware.bluetooth.enable = true;

  services = {
    printing.enable = true;
    openssh.enable = true;
    tlp.enable = true;
    tlp.extraConfig = ''
      DISK_DEVICES="nvme0n1p3"
    '';
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.layout = "us";
  services.xserver.xkbOptions = "eurosign:e";

  # Enable touchpad support.
  services.xserver.libinput.enable = true;

  # Enable the KDE Desktop Environment.
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;

  # Android configuration
  programs.adb.enable = true;
  
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.cguertz = {
     isNormalUser = true;
     shell = pkgs.zsh;
     extraGroups = ["wheel"  "networkmanager" "docker" "input" "audio" "video" "adbusers"]; # Enable ‘sudo’ for the user.
  };

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "19.09"; # Did you read the comment?

}
