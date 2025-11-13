{ config, pkgs, ... }:
{
    dconf.enable = true;
    dconf.settings = {
        "org/gnome/desktop/interface" = {
            color-scheme = "prefer-dark";
            gtk-enable-primary-paste=false;
        };
        "org/gnome/desktop/peripherals/mouse" = {
            speed=-0.45;
        };
        "org/gnome/desktop/peripherals/touchpad" = {
            natural-scroll=false;
            two-finger-scrolling-enabled=true;
        };
        "org/gnome/desktop/wm/keybindings" = {
            switch-applications=[];
            switch-applications-backwards=[];
            switch-windows=["<Alt>Tab"];
            switch-windows-backwards=["<Shift><Alt>Tab"];
            switch-input-source=[];
            switch-input-source-backward=[];
            switch-to-workspace-left=["<Control><Super>Left"];
            switch-to-workspace-right=["<Control><Super>Right"];
        };
        "org/gnome/settings-daemon/plugins/media-keys" = {
            home = ["<Super>e"];
        };
        "org/gnome/mutter" = {
            center-new-windows=true;
        };
        "org/gnome/shell" = {
            favorite-apps=[];
        };
        "org/gnome/shell/app-switcher" = {
            current-workspace-only=true;
        };
        "org/gnome/desktop/search-providers" = {
            disabled = [
                "org.gnome.Contacts.desktop"
                "org.gnome.Calendar.desktop"
                "org.gnome.Characters.desktop"
                "org.gnome.clocks.desktop"
                "org.gnome.Epiphany.desktop"
            ];
        };
        "org/gnome/desktop/wm/preferences" = {
            button-layout = "appmenu:minimize,maximize,close";
        };
        "org/gnome/desktop/interface" = {
            monospace-font-name = "MesloLGM Nerd Font Mono 10";
        };

        "org/gnome/nautilus/preferences" = {
            default-folder-viewer="list-view";
            migrated-gtk-settings=true;
            search-filter-time-type="last_modified";
        };
        "org/gnome/shell" = {
            enabled-extensions=[
                pkgs.gnomeExtensions.burn-my-windows.extensionUuid
                pkgs.gnomeExtensions.desktop-cube.extensionUuid
                pkgs.gnomeExtensions.vscode-search-provider.extensionUuid
                pkgs.gnomeExtensions.tactile.extensionUuid
                pkgs.gnomeExtensions.clipboard-indicator.extensionUuid
                pkgs.gnomeExtensions.display-configuration-switcher.extensionUuid
                pkgs.gnomeExtensions.just-perfection.extensionUuid
                pkgs.gnomeExtensions.open-bar.extensionUuid
            ];
        };
        "org/gnome/shell/keybindings" = {
            show-screenshot-ui=["<Control><Super>s"];
            toggle-message-tray=[];
        };
        "org/gnome/shell/extensions/blur-my-shell/appfolder" = {
            brightness=0.6;
            sigma=30;
        };
        "org/gnome/shell/extensions/blur-my-shell/panel" = {
            brightness=0.6;
            sigma=30;
        };
        "org/gnome/shell/extensions/blur-my-shell/window-list" = {
            brightness=0.6;
            sigma=30;
        };
        "org/gnome/shell/extensions/desktop-cube" = {
            enable-desktop-dragging=true;
            enable-desktop-edge-switch=false;
            workpace-separation=100;
        };
        "org/gnome/shell/extensions/tactile" = {
            col-0=2;
            col-3=2;
            show-tiles=["<Super>space"];
        };
        "org/gnome/shell/extensions/clipboard-indicator" = {
            strip-text=true;
            move-item-first=true;
            toggle-menu=["<Super>v"];
        };
        "org/gnome/shell/extensions/just-perfection" = {
            quick-settings-dark-mode=false;
            weather=false;
            ripple-box=false;
            window-demands-attention-focus=true;
            startup-status=0;
        };
    };
}