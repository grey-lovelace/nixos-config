# Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, nixpkgs2405, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ./hardware-configuration-base.nix 
      ./kanata.nix
      ./nvidia-egpu.nix
      ./gaming.nix
    ];

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  # Enable the Flakes feature and the accompanying new nix command-line tool
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.extraModulePackages = with config.boot.kernelPackages; [ v4l2loopback ];
  boot.kernelModules = [
    #  helpful for  obs virtual camera
    "v4l2loopback"
  ];

  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.hostName = "nixos"; # Define your hostname.
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/Chicago";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Enable the X11 windowing system.
  #  services.xserver.enable = true;
  services.xserver.videoDrivers = [ "amdgpu" ];

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.grey = {
    isNormalUser = true;
    description = "Grey Lovelace";
    extraGroups = [ "networkmanager" "wheel" "audio" "docker" ];
    packages = with pkgs; [];
  };

  # Seems to cause problems on startup, and need to log in anyway for gnome accounts
  # services.displayManager.autoLogin = {
  #   enable = true;
  #   user = "grey";
  # };

  security.pam.loginLimits = [
    { domain = "@audio"; item = "memlock"; type = "-"; value = "unlimited"; }
    { domain = "@audio"; item = "rtprio"; type = "-"; value = "99"; }
    { domain = "@audio"; item = "nofile"; type = "soft"; value = "99999"; }
    { domain = "@audio"; item = "nofile"; type = "hard"; value = "99999"; }
  ];

  fonts.packages = with pkgs; [
    (nerdfonts.override { fonts = [ "Meslo" ]; })
  ];
  environment.sessionVariables = {
    # This doesn't work for now. Will launch apps with native Wayland support,
    # but if running through Nvidia, will fail to launch apps like chrome and vscode
    # NIXOS_OZONE_WL =  "1";
  };
  environment.systemPackages = [
    # terminal tools
    pkgs.neofetch
    pkgs.dconf
    pkgs.wget
    pkgs.wl-clipboard
    pkgs.lshw
    pkgs.yt-dlp

    # developer tools
    pkgs.git
    pkgs.nodejs_23
    pkgs.yarn
    pkgs.deno
    pkgs.jdk23
    pkgs.python314
    pkgs.poetry
    pkgs.gcc
    pkgs.vscode
    pkgs.awscli2
    pkgs.aws-sam-cli
    pkgs.azure-cli
    pkgs.gnumake
    pkgs.bruno
    pkgs.terraform

    # apps
    (pkgs.chromium.override {
      enableWideVine = true;
    })
    pkgs.firefox
    pkgs.obs-studio
    pkgs.slack
    nixpkgs2405.ardour
    pkgs.vlc
    pkgs.gimp
    pkgs.blender
    pkgs.godot_4
    pkgs.discord
    pkgs.kdePackages.kdenlive
    pkgs.kdePackages.breeze

    # gnome
    pkgs.gnome-extension-manager
    pkgs.gnome-tweaks

    # gnome extensions
    pkgs.gnomeExtensions.blur-my-shell
    pkgs.gnomeExtensions.burn-my-windows
    pkgs.gnomeExtensions.desktop-cube
    pkgs.gnomeExtensions.vscode-search-provider
    pkgs.gnomeExtensions.tactile
    pkgs.gnomeExtensions.clipboard-indicator
    pkgs.gnomeExtensions.display-configuration-switcher
    pkgs.gnomeExtensions.just-perfection
  ];

  # Perform garbage collection weekly to maintain low disk usage
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 1w";
  };

  virtualisation.docker.enable = true;

  services.ollama = {
    enable = true;
    loadModels = [
      "deepseek-r1:14b"
    ];
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?

}
