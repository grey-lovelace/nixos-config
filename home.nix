{ config, pkgs, ... }:

{
  home.username = "grey";
  home.homeDirectory = "/home/grey";

  imports = [
    ./oh-my-posh.nix
  ];


  # link the configuration file in current directory to the specified location in home directory
  # home.file.".config/i3/wallpaper.jpg".source = ./wallpaper.jpg;

  # link all files in `./scripts` to `~/.config/i3/scripts`
  # home.file.".config/i3/scripts" = {
  #   source = ./scripts;
  #   recursive = true;   # link recursively
  #   executable = true;  # make all files executable
  # };

  # set cursor size and dpi for 4k monitor
  # xresources.properties = {
  #   "Xcursor.size" = 16;
  #   "Xft.dpi" = 172;
  # };

  # Packages that should be installed to the user profile.
  home.packages = with pkgs; [
  ];

  # wayland.windowManager.sway = {
  #   enable = true;
  #   wrapperFeatures.gtk = true; # Fixes common issues with GTK 3 apps
  #   config = rec {
  #     modifier = "Mod4";
  #     # Use kitty as default terminal
  #     # terminal = "kitty"; 
  #     # startup = [
  #     #   # Launch Firefox on start
  #     #   {command = "firefox";}
  #     # ];
  #   };
  # };


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
        "blur-my-shell@aunetx"
        "burn-my-windows@schneegans.github.com"
        "tactile@lundal.io"
        "vscode-search-provider@mrmarble.github.com"
        "desktop-cube@schneegans.github.com"
        "clipboard-indicator@tudmotu.com"
        "display-configuration-switcher@knokelmaat.gitlab.com"
        "just-perfection-desktop@just-perfection"
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
    # "org/gnome/shell/extensions/blur-my-shell/dash-to-dock" = {
    #   blur=true;
    #   brightness=0.6;
    #   sigma=30;
    #   static-blur=true;
    #   style-dash-to-dock=0;
    # };
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

  programs.git = {
    enable = true;
    userName = "Grey Lovelace";
    userEmail = "austin.grey.lovelace@gmail.com";
    extraConfig = {
      init = {
        defaultBranch = "main";
      };
    };
  };

  programs.zoxide = {
    enable = true;
  };
  programs.bash = {
    enable = true;
    enableCompletion = true;
    bashrcExtra = ''
      export PATH="$PATH:$HOME/bin:$HOME/.local/bin:$HOME/go/bin"
      export AWS_DEFAULT_PROFILE=dev
      export AWS_DEFAULT_REGION=us-east-1
    '';

    shellAliases = {
      ls="ls -ACHG --color $*";
      gw="./gradlew $*";
      gboot="./gradlew bootRun";
      ns="npm run start";
      dockerkill="docker kill $(docker ps -q)";
      gc="git commit -m $*";
    };
    initExtra = ''
      nixr() {
        git add .
        cd ~/nixos-config
        sudo nixos-rebuild switch --flake .
        echo "Enter Commit Message:"
        read commitMessage
        git commit -m "$commitMessage"
        git push
      }

      gitDeleteAllLocalButCurrent() {
        currentBranch=$(git branch --show-current)
        echo "Deleting all branches but $currentBranch"
        git branch | grep -v "$currentBranch" | xargs git branch -D
      }

      github() {
        tempurl=$(git remote get-url origin)
        tempurl=$(echo $tempurl | sed "s/git@/https:\/\//" )
        tempurl=$(echo $tempurl | sed "s/.com:/.com\//" )
        echo Opening $tempurl...
        xdg-open $tempurl
      }

      gitrap(){
        git branch -m $1
        git push -u origin $1
      }
    '';
  };

  xdg = {
    portal = {
      enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-gtk
        xdg-desktop-portal-wlr
      ];
      config.common.default = "*";
    };
    desktopEntries = {
      chromium-personal = {
        name = "Personal (Chrome)";
        genericName = "Web Browser";
        exec = "chromium --new-window --profile-directory=\"Default\"";
        terminal = false;
        categories = [ "Application" "Network" "WebBrowser" ];
        mimeType = [ "text/html" "text/xml" ];
      };
      chromium-source-allies = {
        name = "Source Allies (Chrome)";
        genericName = "Web Browser";
        exec = "chromium --new-window --profile-directory=\"Profile 1\"";
        terminal = false;
        categories = [ "Application" "Network" "WebBrowser" ];
        mimeType = [ "text/html" "text/xml" ];
      };
      chromium-fmh = {
        name = "FMH (Chrome)";
        genericName = "Web Browser";
        exec = "chromium --new-window --profile-directory=\"Profile 3\"";
        terminal = false;
        categories = [ "Application" "Network" "WebBrowser" ];
        mimeType = [ "text/html" "text/xml" ];
      };
      # chromium-source-allies-wayland = {
      #   name = "Source Allies Wayland (Chrome)";
      #   genericName = "Web Browser";
      #   exec = "chromium --new-window --profile-directory=\"Profile 1\" --ozone-platform=wayland";
      #   terminal = false;
      #   categories = [ "Application" "Network" "WebBrowser" ];
      #   mimeType = [ "text/html" "text/xml" ];
      # };
    };
  };

  # This value determines the home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update home Manager without changing this value. See
  # the home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "24.11";

  # Let home Manager install and manage itself.
  programs.home-manager.enable = true;
}