{ config, pkgs, ... }:

{
  home.username = "grey";
  home.homeDirectory = "/home/grey";

  imports = [
    ./home-gnome.nix
    ./oh-my-posh.nix
  ];

  # Packages that should be installed to the user profile.
  home.packages = with pkgs; [
  ];

  programs.git = {
    enable = true;
    userName = "Grey Lovelace";
    userEmail = "austin.grey.lovelace@gmail.com";
    extraConfig = {
      init = {
        defaultBranch = "main";
        # Sign all commits using ssh key
        commit.gpgsign = true;
        gpg.format = "ssh";
        user.signingkey = "~/.ssh/personal.pub";
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
      touchon="echo 0018:27C6:0113.0001 | sudo tee /sys/bus/hid/drivers/hid-multitouch/bind";
      touchoff="echo 0018:27C6:0113.0001 | sudo tee /sys/bus/hid/drivers/hid-multitouch/unbind";
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

      webm2mp4(){
        (( $# < 1 )) && { echo "Usage: webm2mp4 input.webm [output.mp4]"; return 1; }
        local in="$1"; shift
        local out="''${1:-''${in%.webm}.mp4}"
        ffmpeg -i "$in" \
          -c:v libx264 -preset slow -crf 18 \
          -c:a aac -b:a 320k \
          -vf "pad=ceil(iw/2)*2:ceil(ih/2)*2" \
          -movflags +faststart \
          "$out"
      }
    '';
  };

  home.file."Pictures/icons/personal.png".source = ./resources/personal.png;
  home.file."Pictures/icons/source-allies.png".source = ./resources/source-allies.png;
  home.file."Pictures/icons/gateway.png".source = ./resources/gateway.png;
  home.file."Pictures/icons/hntb.png".source = ./resources/hntb.png;
  home.file."Pictures/icons/curseforge.png".source = ./resources/curseforge.png;

  xdg = {
    portal = {
      enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-gnome
        xdg-desktop-portal-gtk
        xdg-desktop-portal-wlr
        xdg-desktop-portal-cosmic
        kdePackages.xdg-desktop-portal-kde
      ];
      config.common.default = "*";
    };
    desktopEntries = {
      brave-personal = {
        name = "Personal (Brave)";
        genericName = "Web Browser";
        exec = "brave --new-window --profile-directory=\"Profile 1\"";
        terminal = false;
        categories = [ "Application" "Network" "WebBrowser" ];
        mimeType = [ "text/html" "text/xml" ];
        icon = "/home/grey/Pictures/icons/personal.png";
      };
      brave-source-allies = {
        name = "Source Allies (Brave)";
        genericName = "Web Browser";
        exec = "brave --new-window --profile-directory=\"Profile 2\"";
        terminal = false;
        categories = [ "Application" "Network" "WebBrowser" ];
        mimeType = [ "text/html" "text/xml" ];
        icon = "/home/grey/Pictures/icons/source-allies.png";
      };
      brave-gateway = {
        name = "Gateway (Brave)";
        genericName = "Web Browser";
        exec = "brave --new-window --profile-directory=\"Profile 3\"";
        terminal = false;
        categories = [ "Application" "Network" "WebBrowser" ];
        mimeType = [ "text/html" "text/xml" ];
        icon = "/home/grey/Pictures/icons/gateway.png";
      };
      brave-hntb = {
        name = "HNTB (Brave)";
        genericName = "Web Browser";
        exec = "brave --new-window --profile-directory=\"Profile 5\"";
        terminal = false;
        categories = [ "Application" "Network" "WebBrowser" ];
        mimeType = [ "text/html" "text/xml" ];
        icon = "/home/grey/Pictures/icons/hntb.png";
      };
      curseforge = {
        name = "CurseForge";
        genericName = "CurseForge";
        exec = "appimage-run \"~/Games/curseforge-latest-linux.AppImage\"";
        terminal = false;
        categories = [ "Application" ];
        icon = "/home/grey/Pictures/icons/curseforge.png";
      };
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