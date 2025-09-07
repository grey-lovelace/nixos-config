{ config, pkgs, ... }:

{
  home.username = "grey";
  home.homeDirectory = "/home/grey";

  imports = [
    # ./home-gnome.nix
    ./oh-my-posh.nix
  ];

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
      touchon="echo 0018:27C6:0113.0001 | sudo tee /sys/bus/hid/drivers/hid-multitouch/bind";
      touchoff="echo 0018:27C6:0113.0001 | sudo tee /sys/bus/hid/drivers/hid-multitouch/unbind";
      ai="aider --model bedrock/amazon.nova-pro-v1:0";
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

  xdg = {
    portal = {
      enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-gnome
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