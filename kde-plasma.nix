

{ config, pkgs, ... }:
{
    # Enable the GNOME Desktop Environment.
    services.displayManager.sddm.enable = true;
    services.displayManager.sddm.wayland.enable = true;
    services.desktopManager.plasma6.enable = true;
    # Uncomment below to turn off Wayland
    # services.xserver.enable = true;

    environment.sessionVariables = {
        # This doesn't work for now. Will launch apps with native Wayland support,
        # but if running through Nvidia, will fail to launch apps like chrome and vscode
        # UPDATE seems to be working now after updating to 25+. Keeping an eye on this.
        NIXOS_OZONE_WL =  "1";
    };

    environment.systemPackages = [
        pkgs.kdePackages.krunner
    ];
}