{ lib, pkgs, ... }: {
  imports = [
    ./pc/laptop
    ./pc/laptop/ssd
    ./bluetooth.nix
    ./audio.nix
  ];

  # Fix TRRS headphones missing a mic
  # https://community.frame.work/t/headset-microphone-on-linux/12387/3
  boot.extraModprobeConfig = lib.mkIf (lib.versionOlder pkgs.linux.version "6.6.8") ''
    options snd-hda-intel model=dell-headset-multi
  '';

  # For fingerprint support
  services.fprintd.enable = lib.mkDefault true;

  # Needed for desktop environments to detect/manage display brightness
  hardware.sensor.iio.enable = true;
}
