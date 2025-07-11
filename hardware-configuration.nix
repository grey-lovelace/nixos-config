{ config, lib, pkgs, ... }:

let
  cfg = config.hardware.gpd.duo;
in
with lib; {
  imports = [
    ./common
    ./common/amd.nix
    ./common/audio.nix
    #./common/cpu/amd/raphael/igpu.nix
  ];

  options = {
    # hardware.gpd.duo.preventWakeOnAC = mkOption {
    #   type = types.bool;
    #   default = false;
    #   description = ''
    #     Stop the system waking from suspend when the AC is plugged
    #     in. The catch: it also disables waking from the keyboard.

    #     See:
    #     https://community.frame.work/t/tracking-framework-amd-ryzen-7040-series-lid-wakeup-behavior-feedback/39128/45
    #   '';
    # };
  };

  config = {
    # Workaround applied upstream in Linux >=6.7 (on BIOS 03.03)
    # https://github.com/torvalds/linux/commit/a55bdad5dfd1efd4ed9ffe518897a21ca8e4e193
    # services.udev.extraRules = mkIf (versionOlder config.boot.kernelPackages.kernel.version "6.7" && cfg.preventWakeOnAC) ''
    #   # Prevent wake when plugging in AC during suspend. Trade-off: keyboard wake disabled. See:
    #   # https://community.frame.work/t/tracking-framework-amd-ryzen-7040-series-lid-wakeup-behavior-feedback/39128/45
    #   ACTION=="add", SUBSYSTEM=="serio", DRIVERS=="atkbd", ATTR{power/wakeup}="disabled"
    # '';
  
    # Replace 'left' with 'right' or 'inverted' as needed
    # Fixes DUO stupid inverted display at boot
    # Enable kernel module for your graphics (adjust if needed)
    boot.kernelModules = [ "amdgpu" ];

    # Set the framebuffer or video parameters for display rotation
    boot.kernelParams = [
      "video=eDP-1:1920X1200,panel_orientation=upside_down"
      "fbcon=rotate:2" 
      "video=DP-3:1920X1200"
      "i2c_touchscreen_props=GXTP7380:touchscreen-inverted-x:touchscreen-inverted-y"
    ];

    boot.kernelPackages = pkgs.linuxPackages_6_12;

    hardware.gpd.duo.audioEnhancement.rawDeviceName = lib.mkDefault "alsa_output.pci-0000_c1_00.6.analog-stereo";


  };
}
