

{ config, pkgs, ... }:
{
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

    environment.systemPackages = with pkgs; [
        kdePackages.krunner
        kdePackages.xdg-desktop-portal-kde
        # KDE
        kdePackages.discover # Optional: Install if you use Flatpak or fwupd firmware update sevice
        kdePackages.kcalc # Calculator
        kdePackages.kcharselect # Tool to select and copy special characters from all installed fonts
        kdePackages.kclock # Clock app
        kdePackages.kcolorchooser # A small utility to select a color
        kdePackages.kolourpaint # Easy-to-use paint program
        kdePackages.ksystemlog # KDE SystemLog Application
        kdePackages.sddm-kcm # Configuration module for SDDM
        kdiff3 # Compares and merges 2 or 3 files or directories
        kdePackages.isoimagewriter # Optional: Program to write hybrid ISO files onto USB disks
        kdePackages.partitionmanager # Optional: Manage the disk devices, partitions and file systems on your computer
        kdiff3 # Compares and merges 2 or 3 files or directories
        wayland-utils # Wayland utilities
        hardinfo2 # System information and benchmarks for Linux systems
    ];

    # KDE Exclusions
    environment.plasma6.excludePackages = with pkgs; [
        kdePackages.elisa # Simple music player aiming to provide a nice experience for its users
        kdePackages.kdepim-runtime # Akonadi agents and resources
        kdePackages.kmahjongg # KMahjongg is a tile matching game for one or two players
        kdePackages.kmines # KMines is the classic Minesweeper game
        kdePackages.konversation # User-friendly and fully-featured IRC client
        kdePackages.kpat # KPatience offers a selection of solitaire card games
        kdePackages.ksudoku # KSudoku is a logic-based symbol placement puzzle
        kdePackages.ktorrent # Powerful BitTorrent client
        mpv
    ];
}