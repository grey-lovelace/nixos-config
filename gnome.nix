{ config, pkgs, ... }:
{
    # Enable the GNOME Desktop Environment.
    # services.xserver.displayManager.gdm.enable = true;
    # services.xserver.displayManager.gdm.wayland = true;
    services.xserver.desktopManager.gnome.enable = true;
    # Uncomment below to turn off Wayland
    # services.xserver.enable = true;

    systemd.tmpfiles.rules = [
        # Make Gnome login screen right side up on the native laptop screen. This only is in effect when no user is currently logged in.
        ''f+ /run/gdm/.config/monitors.xml - gdm gdm - ${builtins.readFile ./resources/initial_login_monitors.xml}''
    ];

    environment.sessionVariables = {
        # This doesn't work for now. Will launch apps with native Wayland support,
        # but if running through Nvidia, will fail to launch apps like chrome and vscode
        # UPDATE seems to be working now after updating to 25+. Keeping an eye on this.
        NIXOS_OZONE_WL =  "1";
    };

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