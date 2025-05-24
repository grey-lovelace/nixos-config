{ config, lib, pkgs, ... }:
{
    programs.gamemode.enable = true; # for performance mode
    
    programs.steam = {
        enable = true;
        remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
        dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
        localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
    };

    environment.systemPackages = with pkgs; [
        heroic
        steam-rom-manager
        dolphin-emu
        ryujinx
        openrazer-daemon
        polychromatic
        (retroarch.override {
            cores = with libretro; [
                citra
                snes9x
                desmume
                dolphin
                gambatte
                mgba
                mupen64plus
                ppsspp
                pcsx-rearmed
                pcsx2
            ];
        })
    ];
}