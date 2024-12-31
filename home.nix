{ config, pkgs, ... }:

{
  home.username = "grey";
  home.homeDirectory = "/home/grey";


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
        "clipboard-indicator@tudmoto.com"
        "display-configuration-switcher@knokelmaat.gitlab.com"
      ];
    };
    "org/gnome/shell/extensions/blur-my-shell/appfolder" = {
      brightness=0.6;
      sigma=30;
    };
    "org/gnome/shell/extensions/blur-my-shell/dash-to-dock" = {
      blur=true;
      brightness=0.6;
      sigma=30;
      static-blur=true;
      style-dash-to-dock=0;
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
  programs.oh-my-posh = {
    enable = true;
    settings = {
      schema =  "https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/main/themes/schema.json";
      blocks =  [
        {
          alignment =  "left";
          segments =  [
            {
              background =  "#575656";
              foreground =  "#FFFFFF";
              leading_diamond =  "\ue0b6";
              style =  "diamond";
              template =  "{{ .Icon }} ";
              type =  "os";
            }
            {
              background =  "#575656";
              foreground =  "#ffffff";
              style =  "diamond";
              trailing_diamond =  "\uE0B0";
              template =  "{{ .UserName }} ";
              type =  "session";
            }
            {
              background =  "#91ddff";
              foreground =  "#100e23";
              powerline_symbol =  "\ue0b0";
              properties =  {
                folder_icon =  "\uf115";
                folder_separator_icon =  " \ue0b1 ";
                home_icon =  "\uf7db";
                style =  "full";
              };
              style =  "powerline";
              template =  " {{ .Path }} ";
              type =  "path";
            }
            {
              background =  "#95ffa4";
              background_templates =  [
                "{{ if or (.Working.Changed) (.Staging.Changed) }}#FFEB3B{{ end }}"
                "{{ if and (gt .Ahead 0) (gt .Behind 0) }}#FFA300{{ end }}"
                "{{ if gt .Ahead 0 }}#FF7070{{ end }}"
                "{{ if gt .Behind 0 }}#90F090{{ end }}"
              ];
              foreground =  "#193549";
              style =  "diamond";
              leading_diamond =  "<transparent,background>\uE0B0</>";
              trailing_diamond =  "\uE0B0";
              properties =  {
                fetch_status =  true;
                fetch_upstream_icon =  true;
              };
              template =  " {{ .UpstreamIcon }}{{ .HEAD }}{{ .BranchStatus }}";
              type =  "git";
            }
            {
              type =  "java";
              style =  "diamond";
              leading_diamond =  "<transparent,background>\uE0B0</>";
              trailing_diamond =  "\uE0B0";
              foreground =  "#ffffff";
              background =  "#4063D8";
              template =  " \uE738 {{ .Full }} ";
              display_mode =  "files";
            }
            {
              type =  "node";
              style =  "diamond";
              leading_diamond =  "<transparent,background>\uE0B0</>";
              trailing_diamond =  "\uE0B0";
              foreground =  "#ffffff";
              background =  "#6CA35E";
              template =  " \uE718 {{ .Full }} ";
              display_mode =  "files";
            }
            {
              type =  "python";
              style =  "diamond";
              leading_diamond =  "<transparent,background>\uE0B0</>";
              trailing_diamond =  "\uE0B0";
              foreground =  "#100e23";
              background =  "#906cff";
              template =  " \uE235 {{ .Full }} ";
              display_mode =  "files";
            }
            {
              background =  "#f1184c";
              foreground =  "#ffffff";
              style =  "diamond";
              leading_diamond =  "<transparent,background>\uE0B0</>";
              trailing_diamond =  "\uE0B0";
              template =  " (╯°□°)╯彡┻━┻ ";
              type =  "exit";
              properties =  {
                always_enabled =  false;
              };
            }
          ];
          type = "prompt";
        }
        {
          alignment =  "left";
          newline =  true;
          segments =  [
            {
              foreground =  "#007ACC";
              style =  "plain";
              template =  "\u276f ";
              type =  "text";
            }
          ];
          type =  "prompt";
        }
      ];
      version =  2;
    };
  };
  programs.bash = {
    enable = true;
    enableCompletion = true;
    bashrcExtra = ''
      export PATH="$PATH:$HOME/bin:$HOME/.local/bin:$HOME/go/bin"
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
        sudo nixos-rebuild switch
        cd ~/nixos-config
        git add .
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

  xdg.desktopEntries = {
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