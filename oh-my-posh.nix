{ config, pkgs, ... }:

{
  programs.oh-my-posh = {
    enable = true;
    settings = 
      builtins.fromJSON (builtins.unsafeDiscardStringContext ''
        {
          "$schema": "https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/main/themes/schema.json",
          "blocks": [
            {
              "alignment": "left",
              "segments": [
                {
                  "background": "#575656",
                  "foreground": "#FFFFFF",
                  "leading_diamond": "\ue0b6",
                  "style": "diamond",
                  "template": "{{ .Icon }} ",
                  "type": "os"
                },
                {
                  "background": "#575656",
                  "foreground": "#ffffff",
                  "style": "diamond",
                  "trailing_diamond": "\uE0B0",
                  "template": "{{ .UserName }} ",
                  "type": "session"
                },
                {
                  "background": "#91ddff",
                  "foreground": "#100e23",
                  "powerline_symbol": "\ue0b0",
                  "properties": {
                    "folder_icon": "\uf115",
                    "folder_separator_icon": " \ue0b1 ",
                    "home_icon": "\uf015",
                    "style": "full"
                  },
                  "style": "powerline",
                  "template": " {{ .Path }} ",
                  "type": "path"
                },
                {
                  "background": "#95ffa4",
                  "background_templates": [
                    "{{ if or (.Working.Changed) (.Staging.Changed) }}#FFEB3B{{ end }}",
                    "{{ if and (gt .Ahead 0) (gt .Behind 0) }}#FFA300{{ end }}",
                    "{{ if gt .Ahead 0 }}#FF7070{{ end }}",
                    "{{ if gt .Behind 0 }}#90F090{{ end }}"
                  ],
                  "foreground": "#193549",
                  "style": "diamond",
                  "leading_diamond": "<transparent,background>\uE0B0</>",
                  "trailing_diamond": "\uE0B0",
                  "properties": {
                    "fetch_status": true,
                    "fetch_upstream_icon": true
                  },
                  "template": " {{ .UpstreamIcon }}{{ .HEAD }}{{ .BranchStatus }}",
                  "type": "git"
                },
                {
                  "type": "java",
                  "style": "diamond",
                  "leading_diamond": "<transparent,background>\uE0B0</>",
                  "trailing_diamond": "\uE0B0",
                  "foreground": "#ffffff",
                  "background": "#4063D8",
                  "template": " \uE738 {{ .Full }} ",
                  "display_mode": "files"
                },
                {
                  "type": "node",
                  "style": "diamond",
                  "leading_diamond": "<transparent,background>\uE0B0</>",
                  "trailing_diamond": "\uE0B0",
                  "foreground": "#ffffff",
                  "background": "#6CA35E",
                  "template": " \uE718 {{ .Full }} ",
                  "display_mode": "files"
                },
                {
                  "type": "python",
                  "style": "diamond",
                  "leading_diamond": "<transparent,background>\uE0B0</>",
                  "trailing_diamond": "\uE0B0",
                  "foreground": "#100e23",
                  "background": "#906cff",
                  "template": " \uE235 {{ .Full }} ",
                  "display_mode": "files"
                },
                {
                  "background": "#f1184c",
                  "foreground": "#ffffff",
                  "style": "diamond",
                  "leading_diamond": "<transparent,background>\uE0B0</>",
                  "trailing_diamond": "\uE0B0",
                  "template": " (╯°□°)╯彡┻━┻ ",
                  "type": "exit",
                  "properties": {
                    "always_enabled": false
                  }
                }
              ],
              "type": "prompt"
            },
            {
              "alignment": "left",
              "newline": true,
              "segments": [
                {
                  "foreground": "#007ACC",
                  "style": "plain",
                  "template": "\u276f ",
                  "type": "text"
                }
              ],
              "type": "prompt"
            }
          ],
          "version": 2
        }
      '');
  };
}