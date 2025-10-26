# Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, nixpkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ./hardware-configuration-base.nix 
      ./kanata.nix
      ./nvidia-egpu.nix
      ./gaming.nix
      ./cosmic.nix
      ./gnome.nix
      # ./kde-plasma.nix
    ];

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  # Enable the Flakes feature and the accompanying new nix command-line tool
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

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

  # Enable Bluetooth
  hardware = {
    bluetooth = {
        enable = true;
        settings.General.Experimental = true;
    };
  };

  # Enable sound with pipewire.
  security.rtkit.enable = true;
  services.pulseaudio.enable = false;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  users.users.grey = {
    isNormalUser = true;
    description = "Grey Lovelace";
    extraGroups = [ "networkmanager" "wheel" "audio" "docker" ];
    packages = with pkgs; [];
  };

  security.pam.loginLimits = [
    { domain = "@audio"; item = "memlock"; type = "-"; value = "unlimited"; }
    { domain = "@audio"; item = "rtprio"; type = "-"; value = "99"; }
    { domain = "@audio"; item = "nofile"; type = "soft"; value = "99999"; }
    { domain = "@audio"; item = "nofile"; type = "hard"; value = "99999"; }
  ];

  fonts.packages = with pkgs; [
    nerd-fonts.meslo-lg
    open-sans
  ];
  
  environment.systemPackages = [
    # terminal tools
    pkgs.neofetch
    pkgs.dconf
    pkgs.wget
    pkgs.wl-clipboard
    pkgs.lshw
    pkgs.yt-dlp
    pkgs.ghostty
    pkgs.qmk
    pkgs.libinput
    pkgs.xorg.xlsclients
    pkgs.zip

    # developer tools
    pkgs.git
    pkgs.nodejs_24
    pkgs.yarn
    pkgs.deno
    pkgs.jdk23
    pkgs.python314
    pkgs.python3Packages.evdev
    pkgs.poetry
    pkgs.uv
    pkgs.cargo
    pkgs.rustc
    pkgs.gcc
    pkgs.vscode
    pkgs.awscli2
    pkgs.aws-sam-cli
    pkgs.azure-cli
    pkgs.gnumake
    pkgs.bruno
    pkgs.terraform
    pkgs.duckdb
    pkgs.kind
    pkgs.lazygit
    pkgs.lazydocker
    pkgs.poppler_utils
    pkgs.zoom-us
    pkgs.openssl
    pkgs.go

    # apps
    (pkgs.chromium.override {
      enableWideVine = true;
    })
    pkgs.slack
    pkgs.ardour
    pkgs.vlc
    pkgs.gimp
    pkgs.krita
    pkgs.aseprite
    pkgs.blender
    pkgs.godot_4
    pkgs.discord
    pkgs.kdePackages.kdenlive
    pkgs.kdePackages.breeze
    pkgs.shotcut
    pkgs.bitwarden-desktop
    pkgs.libreoffice
    pkgs.ffmpeg
    pkgs.ani-cli
    pkgs.inkscape
    pkgs.appimage-run

    # VLC encoding/conversion
    pkgs.libdvdnav
    pkgs.libdvdread
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

  services.open-webui = {
    enable = true;
  };

  # enable Sway window manager
  # programs.sway = {
  #   enable = true;
  #   wrapperFeatures.gtk = true;
  # };
  # security.polkit.enable = true;

  programs.ssh = {
    startAgent = true;
    # enableAskPassword = true;
    extraConfig = ''
    # Test if github.com works with ssh for cloning
    Host github.com
    IdentityFile ~/.ssh/personal
    '';
  };
  # environment.variables = {
  #   SSH_ASKPASS_REQUIRE = "prefer";
  # };

  programs.obs-studio = {
    enable = true;
    enableVirtualCamera = true;
    plugins = with pkgs.obs-studio-plugins; [
      wlrobs
      obs-backgroundremoval
      obs-pipewire-audio-capture
    ];
  };

  # boot.extraModulePackages = with config.boot.kernelPackages; [ v4l2loopback ];
  # boot.kernelModules = [
  #   #  helpful for  obs virtual camera
  #   "v4l2loopback"
  # ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?

}
