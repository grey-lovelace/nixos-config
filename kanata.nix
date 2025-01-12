{
  config,
  lib,
  pkgs,
  ...
}:

{
  # Enable the uinput module
  boot.kernelModules = [ "uinput" ];

  # Enable uinput
  hardware.uinput.enable = true;

  # Set up udev rules for uinput
  services.udev.extraRules = ''
    KERNEL=="uinput", MODE="0660", GROUP="uinput", OPTIONS+="static_node=uinput"
  '';

  # Ensure the uinput group exists
  users.groups.uinput = { };

  # Add the Kanata service user to necessary groups
  systemd.services.kanata-internalKeyboard.serviceConfig = {
    SupplementaryGroups = [
      "input"
      "uinput"
    ];
  };

  services.kanata = {
    enable = true;
    keyboards = {
      internalKeyboard = {
        # Instead, use the built in device recognition to target all keyboards
        # devices = [
        #   "/dev/input/by-path/platform-i8042-serio-0-event-kbd"
        #   "/dev/input/by-path/pci-0000:00:14.0-usb-0:3:1.0-event-kbd"
        # ];
        extraDefCfg = "process-unmapped-keys yes";
        config = ''
          (defsrc
            esc  f1   f2   f3   f4   f5   f6   f7   f8   f9   f10  f11  f12  del
            grv  1    2    3    4    5    6    7    8    9    0    -    =    bspc
            tab  q    w    e    r    t    y    u    i    o    p    [    ]    \
            caps a    s    d    f    g    h    j    k    l    ;    '    ret
            lsft z    x    c    v    b    n    m    ,    .    /    rsft
            lctl   lmet lalt           spc            ralt rmet rctl
          )
          (defalias
            nav  (layer-toggle navigation)
            escnav (tap-hold 200 200 esc @nav)
            spcsft (tap-hold 200 200 spc lsft)
            vdr M-C-right
            vdl M-C-left
            tabl C-pgup
            tabr C-pgdn
          )
          (deflayer base
            esc  f1   f2   f3   f4   f5   f6   f7   f8   f9   f10  f11  f12  del
            grv  1    2    3    4    5    6    7    8    9    0    -    =    bspc
            tab  q    w    e    r    t    y    u    i    o    p    [    ]    \
            @escnav a    s    d    f    g    h    j    k    l    ;    '    ret
            lctl z    x    c    v    b    n    m    ,    .    /    grv
            lsft   lmet lalt           @spcsft       ralt rmet rctl
          )
          (deflayer navigation
            XX   XX   XX   XX   XX   XX  XX    XX    XX   XX   XX    XX   XX   XX
            XX   XX   XX   XX   XX   XX  XX    XX    XX   XX   XX    XX   XX   XX
            XX   @vdl @vdr XX   bspc del pgup  home  end  XX   XX    XX   XX   XX
            XX   XX   XX   XX   lctl XX  pgdn  left  up   down right XX   XX
            XX   XX   XX   XX   XX   XX  @tabl @tabr XX   XX   XX    XX
            XX   XX   XX             _               XX   XX   XX   
          )
        '';
      };
    };
  };
}