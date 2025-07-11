# Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, nixpkgs-unstable, nixpkgs2405, pkgs, ... }:

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

  # boot.extraModulePackages = with config.boot.kernelPackages; [ v4l2loopback ];
  # boot.kernelModules = [
  #   #  helpful for  obs virtual camera
  #   "v4l2loopback"
  # ];

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

  
  services.xserver.videoDrivers = [ "amdgpu" ];

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.displayManager.gdm.wayland = true;
  services.xserver.desktopManager.gnome.enable = true;
  # Uncomment below to turn off Wayland
  # services.xserver.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };
  services.libinput = {
    # Set "ignore" to true to disable the touchscreen.
    enable = true;
    # touchscreen.ignore = true;
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  security.rtkit.enable = true;
  services.pulseaudio.enable = false;
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
    nerd-fonts.meslo-lg
  ];
  environment.sessionVariables = {
    # This doesn't work for now. Will launch apps with native Wayland support,
    # but if running through Nvidia, will fail to launch apps like chrome and vscode
    # UPDATE seems to be working now after updating to 25+. Keeping an eye on this.
    NIXOS_OZONE_WL =  "1";
  };
  environment.systemPackages = [
    # terminal tools
    nixpkgs-unstable.neofetch
    nixpkgs-unstable.dconf
    nixpkgs-unstable.wget
    nixpkgs-unstable.wl-clipboard
    nixpkgs-unstable.lshw
    nixpkgs-unstable.yt-dlp
    nixpkgs-unstable.ghostty
    nixpkgs-unstable.qmk
    nixpkgs-unstable.libinput

    # developer tools
    nixpkgs-unstable.git
    nixpkgs-unstable.nodejs_24
    nixpkgs-unstable.yarn
    nixpkgs-unstable.deno
    nixpkgs-unstable.jdk23
    nixpkgs-unstable.python314
    nixpkgs-unstable.poetry
    nixpkgs-unstable.uv
    nixpkgs-unstable.cargo
    nixpkgs-unstable.rustc
    nixpkgs-unstable.gcc
    nixpkgs-unstable.vscode
    nixpkgs-unstable.awscli2
    nixpkgs-unstable.aws-sam-cli
    nixpkgs-unstable.azure-cli
    nixpkgs-unstable.gnumake
    nixpkgs-unstable.bruno
    nixpkgs-unstable.terraform
    nixpkgs-unstable.duckdb
    nixpkgs-unstable.lazygit
    nixpkgs-unstable.lazydocker
    nixpkgs-unstable.poppler_utils
    nixpkgs-unstable.zoom-us

    # apps
    (nixpkgs-unstable.chromium.override {
      enableWideVine = true;
    })
    # nixpkgs-unstable.obs-studio
    nixpkgs-unstable.slack
    nixpkgs-unstable.ardour
    nixpkgs-unstable.vlc
    nixpkgs-unstable.gimp
    nixpkgs-unstable.krita
    nixpkgs-unstable.aseprite
    nixpkgs-unstable.blender
    nixpkgs-unstable.godot_4
    nixpkgs-unstable.discord
    nixpkgs-unstable.kdePackages.kdenlive
    nixpkgs-unstable.kdePackages.breeze
    nixpkgs-unstable.bitwarden-desktop
    nixpkgs-unstable.libreoffice
    nixpkgs-unstable.ffmpeg
    nixpkgs-unstable.ani-cli

    # VLC encoding/conversion
    nixpkgs-unstable.libdvdnav
    nixpkgs-unstable.libdvdread

    # gnome
    pkgs.gnome-extension-manager
    pkgs.gnome-tweaks

    # gnome extensions
    # pkgs.gnomeExtensions.blur-my-shell
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
  hardware.keyboard.qmk.enable = true;

  services.fprintd = {
    enable = true;
  };

  services.ollama = {
    enable = true;
    loadModels = [
      "deepseek-r1:14b"
      "qwen3:14b"
    ];
  };

  systemd.tmpfiles.rules = [
    # Make Gnome login screen right side up on the native laptop screen. This only is in effect when no user is currently logged in.
    ''f+ /run/gdm/.config/monitors.xml - gdm gdm - ${builtins.readFile ./resources/initial_login_monitors.xml}''
    # ''f+ /run/gdm/.config/monitors.xml - gdm gdm - <monitors version="2"><configuration><layoutmode>physical</layoutmode><logicalmonitor><x>0</x><y>0</y><scale>1</scale><primary>yes</primary><transform><rotation>upside_down</rotation><flipped>no</flipped></transform><monitor><monitorspec><connector>eDP-1</connector><vendor>SDC</vendor><product>0x4166</product><serial>0x00000000</serial></monitorspec><mode><width>1920</width><height>1200</height><rate>60.001</rate></mode></monitor></logicalmonitor></configuration></monitors>''
  ];

  # enable Sway window manager
  # programs.sway = {
  #   enable = true;
  #   wrapperFeatures.gtk = true;
  # };
  # security.polkit.enable = true;

  programs.obs-studio = {
    enable = true;
    enableVirtualCamera = true;
    plugins = with pkgs.obs-studio-plugins; [
      wlrobs
      obs-backgroundremoval
      obs-pipewire-audio-capture
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
