{ config, lib, pkgs, ... }:
{
    programs.gamemode.enable = true; # for performance mode
    
    programs.steam = {
        enable = true;
        remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
        dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
        localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
    };

    hardware.openrazer.enable = true;
    environment.systemPackages = with pkgs; [
        heroic
        steam-rom-manager
        dolphin-emu
        # ryujinx
        # ryubing
        openrazer-daemon
        polychromatic
        (retroarch.withCores (cores: with cores; [
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
        ]))
    ];
}