{ config, lib, pkgs, nixpkgs-unstable, ... }:
{

  # Enable OpenGL
  hardware.graphics = {
    enable = true;
  };

  services.xserver.videoDrivers = ["nvidia"];

  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false;
    powerManagement.finegrained = false;
    open = false;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
    prime = {
      sync.enable = true;
      nvidiaBusId = "PCI:197:0:0";
      amdgpuBusId = "PCI:199:0:0";
    };
  };

  environment.systemPackages = [
    nixpkgs-unstable.nvtopPackages.nvidia
  ];
}