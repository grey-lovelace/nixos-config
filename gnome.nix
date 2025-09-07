{ config, pkgs, ... }:
{
    # Enable the GNOME Desktop Environment.
    services.displayManager.gdm.enable = true;
    services.displayManager.gdm.wayland = true;
    services.desktopManager.gnome.enable = true;
    # Uncomment below to turn off Wayland
    # services.xserver.enable = true;

    environment.systemPackages = [
        # gnome
        pkgs.gnome-extension-manager
        pkgs.gnome-tweaks

        # gnome extensions
        pkgs.gnomeExtensions.burn-my-windows
        pkgs.gnomeExtensions.desktop-cube
        pkgs.gnomeExtensions.vscode-search-provider
        pkgs.gnomeExtensions.tactile
        pkgs.gnomeExtensions.clipboard-indicator
        pkgs.gnomeExtensions.display-configuration-switcher
        pkgs.gnomeExtensions.just-perfection
    ];
}