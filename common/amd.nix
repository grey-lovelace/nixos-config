{ lib, config, ... }: with lib; {
  imports = [
    ./cpu/amd
    ./cpu/amd/pstate.nix
    ./gpu/amd
  ];

  boot.kernelParams =
    [
      # There seems to be an issue with panel self-refresh (PSR) that
      # causes hangs for users.
      #
      # https://community.frame.work/t/fedora-kde-becomes-suddenly-slow/58459
      # https://gitlab.freedesktop.org/drm/amd/-/issues/3647
      "amdgpu.dcdebugmask=0x210"
    ]
    # Workaround for SuspendThenHibernate: https://lore.kernel.org/linux-kernel/20231106162310.85711-1-mario.limonciello@amd.com/
    ++ optionals (versionOlder config.boot.kernelPackages.kernel.version "6.8") [ "rtc_cmos.use_acpi_alarm=1" ];

  # AMD has better battery life with PPD over TLP:
  # https://community.frame.work/t/responded-amd-7040-sleep-states/38101/13
  services.power-profiles-daemon.enable = mkDefault true;
  services.tlp.enable = mkDefault false;
}
