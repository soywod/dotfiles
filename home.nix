{ config, lib, nixpkgs, pkgs, ... }:

let
  mod = config.wayland.windowManager.sway.config.modifier;
  theme = import ./theme.nix;
in {
  nixpkgs.config.allowUnfree = true;
    
  imports = [
    (import ./programs/bash { inherit pkgs; })
    (import ./programs/dunst { inherit pkgs config; })
    (import ./programs/ergodox { inherit pkgs; })
    (import ./programs/direnv { inherit pkgs; })
    (import ./programs/emacs { inherit pkgs; })
  ];

  home = {
    packages = with pkgs; [
      brightnessctl
      firefox
      gammastep
      ripgrep
      mpv
      xdg-utils
      gimp
      inkscape
      tdesktop
      wally-cli
    ];
    sessionPath = [
      "$HOME/.local/bin"
    ];
    sessionVariables = {
      EDITOR = "emacs";
      GIT_PROMPT_FETCH_REMOTE_STATUS = 0;
      GIT_PROMPT_IGNORE_SUBMODULES = 1;
      GIT_PROMPT_WITH_VIRTUAL_ENV = 0;
      GIT_PROMPT_SHOW_UNTRACKED_FILES = "no";
      GIT_PROMPT_START = "_LAST_COMMAND_INDICATOR_ \\[\\e[36m\\]\\W\\[\\e[m\\]";
      GIT_PROMPT_END = " \\[\\e[31m\\]➜\\[\\e[m\\] ";
      GIT_PROMPT_COMMAND_OK = "";
    };    
  };

  programs.home-manager = {
    enable = true;
  };

  programs.waybar = {
    enable = true;
    settings = [
      {
        layer = "top";
        position = "top";
        height = 15;
        modules-left = [
          "battery"
          "temperature"
          "cpu"
          "memory"
          "disk"
          "network"
          "backlight"
          "pulseaudio"
        ];
        modules-center = [
          "clock"
        ];
        modules-right = [
          "sway/mode"
          "tray"
        ];
        modules = {
          battery = {
            states = {
              good = 95;
              warning = 30;
              critical = 15;
            };
            format = "{icon} {capacity}%";
            format-alt = "{time}";
            format-full = "";
            format-charging = " {capacity}%";
            format-plugged = " {capacity}%";
            format-icons = ["" "" "" "" ""];
          };
          temperature = {
            interval = 1;
            tooltip = false;
            thermal-zone = 1;
            critical-threshold = 80;
            format = "{icon} {temperatureC}°C";
            format-critical = "{icon} {temperatureC}°C";
            format-icons = ["" "" "" "" ""];
          };
          cpu = {
            interval = 1;
            tooltip = false;
            format = " {usage}%";
          };
          memory = {
            interval = 1;
            format = " {percentage}%";
            tooltip-format = "{used:0.1f}GiB/{avail:0.1f}GiB";
          };
          disk = {
            interval = 60;
            path = "/";
            format = " {percentage_free}%";
            tooltip-format = "{used}/{total}";
          };
          
          network = {
            interval = 1;
            interface = "wlp*";
            format-wifi = " {signalStrength}%";
            tooltip-format-wifi = "IP = {ipaddr}\nSSID = {essid}";
            format-ethernet = "";
            tooltip-format-ethernet = "IP = {ipaddr}";
            format-disconnected = "";
          };
          backlight = {
            tooltip = false;
            format = " {percent}%";
          };
          pulseaudio = {
            scroll-step = 2;
            format = "{icon} {volume}%";
            format-bluetooth = " {icon} {volume}%";
            format-muted = "";
            format-icons = {
              headphone = "";
              headset = "";
              default = ["" ""];
            };
          };
          clock = {
            timezone = "Europe/Paris";
            tooltip = false;
            format = "{:%H:%M, %a %b %e}";
          };
          "sway/mode" = {
            format = "{}";
          };
          tray = {
            icon-size = 16;
            spacing = 8;
          };
        };
      }
    ];
    style = ''
      * {
        font-family: JetBrains Mono, Font Awesome;
        font-size: 1.2rem;
      }
      
      #waybar {
        background-color: #21242b;
        color: #bbc2cf;
        border-bottom: 2px solid #3f444a;
      }
      
      #battery,
      #temperature,
      #cpu,
      #memory,
      #disk,
      #language,
      #backlight,
      #pulseaudio,
      #mode,
      #network {
        padding: 0.5rem 0.75rem;
      }
      
      #battery.good {
        color: #98be65;
      }
      
      #battery.warning {
        color: #da8548;
      }
      
      .critical {
        background-color: #ff6c6b;
        color: #bbc2cf;
      }
      
      #battery.charging {
        color: #ecbe7b;
      }
      
      #tray {
        padding: 0.5rem 0.75rem;
      }
    '';
  };

  programs.gh = {
    enable = true;
    settings = {
      git_protocol = "ssh";
    };
  };
  
  programs.git = {
    enable = true;
    userName = "Clément DOUIN";
    userEmail = "clement.douin@posteo.net";
    signing = {
      signByDefault = true;
      gpgPath = "${pkgs.gnupg}/bin/gpg";
      key = "75F0 AB7C FE01 D077 AEE6  CAFD 353E 4A18 EE0F AB72";
    };
    extraConfig = {
      init = {
        defaultBranch = "master";
      };
    };
  };

  programs.kitty = {
    enable = true;
    settings = {
      font_family = "JetBrains Mono";
      font_size = 15;
      cursor_blink_interval = 1;
      sync_to_monitor = false;
      linux_display_server = "wayland";
      background_opacity = 90;
      touch_scroll_multiplier = 10;
      background = "#282c34";
      foreground = "#bbc2cf";
      selection_background = "#3f444a";
      selection_foreground = "#bbc2cf";
      cursor = "#51afef";
      url_color = "#2257a0";
      color0 = "#3f444a";
      color1 = "#ff6c6b";
      color2 = "#98be65";
      color3 = "#ecbe7b";
      color4 = "#51afef";
      color5 = "#c678dd";
      color6 = "#46d9ff";
      color7 = "#bbc2cf";
      color8 = "#3f444a";
      color9 = "#ff6c6b";
      color10 = "#98be65";
      color11 = "#ecbe7b";
      color12 = "#51afef";
      color13 = "#c678dd";
      color14 = "#46d9ff";
      color15 = "#bbc2cf";
    };
    keybindings = {
      "ctrl+shift+n" = "new_os_window_with_cwd";
    };
  };

  wayland.windowManager.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
    config = {
      menu = "${pkgs.dmenu}/bin/dmenu_path | ${pkgs.dmenu}/bin/dmenu -b -fn JetBrainsMono-15 -nb '${theme.bg}' -nf '${theme.fg}' -sb '${theme.magenta}' -sf '${theme.bg}' | ${pkgs.findutils}/bin/xargs swaymsg exec --";
      modifier = "Mod4";
      terminal = "kitty";
      focus.followMouse = false;
      gaps.inner = 16;
      window.border = 2;
      floating.border = 2;
      bars = [
        {
          command = "waybar";
        }
      ];
      fonts = {
        names = ["JetBrains Mono"];
        style = "Medium";
        size = 12.0;
      };
      input = {
        "type:keyboard" = {
          xkb_layout = "us,ru";
          xkb_variant = "dvorak-alt-intl,";
          xkb_options = "grp:shifts_toggle,numpad:mac,compose:caps,level3:ralt_switch";
          repeat_delay = "250";
          repeat_rate = "33";
        };
        "type:touchpad" = {
          tap = "disabled";
          natural_scroll = "disabled";
        };
      };
      output = {
        eDP-1 = {
          resolution = "1920x1200@60Hz";
          position = "0 0";
          bg = "~/documents/wallpapers/nixos.svg fill";
        };
      };
      keybindings = lib.mkOptionDefault {
        "XF86MonBrightnessDown"              = "exec brightnessctl set 5%-";
        "Shift+XF86MonBrightnessDown"        = "exec brightnessctl set 1%";
        "Shift+${mod}+XF86MonBrightnessDown" = "exec brightnessctl set 1%-";

        "XF86MonBrightnessUp"              = "exec brightnessctl set  5%+";
        "Shift+XF86MonBrightnessUp"        = "exec brightnessctl set 100%";
        "Shift+${mod}+XF86MonBrightnessUp" = "exec brightnessctl set  1%+";

        "XF86AudioLowerVolume"              = "exec pactl set-sink-volume @DEFAULT_SINK@ -5%";
        "Shift+XF86AudioLowerVolume"        = "exec pactl set-sink-volume @DEFAULT_SINK@  1%";
        "Shift+${mod}+XF86AudioLowerVolume" = "exec pactl set-sink-volume @DEFAULT_SINK@ -1%";

        "XF86AudioRaiseVolume"              = "exec pactl set-sink-volume @DEFAULT_SINK@ +5%";
        "Shift+XF86AudioRaiseVolume"        = "exec pactl set-sink-volume @DEFAULT_SINK@ 100%";
        "Shift+${mod}+XF86AudioRaiseVolume" = "exec pactl set-sink-volume @DEFAULT_SINK@ +1%";

        "XF86AudioMute"    = "exec pactl set-sink-mute   @DEFAULT_SINK@ toggle";
        "XF86AudioMicMute" = "exec pactl set-source-mute @DEFAULT_SINK@ toggle";

        "XF86AudioPrev" = "exec playerctl previous";
        "XF86AudioPlay" = "exec playerctl play-pause";
        "XF86AudioNext" = "exec playerctl next";
        
        "Print"              = "exec selection-capture";
        "Shift+Print"        = "exec selection-record";
        "Shift+${mod}+Print" = "exec screen-capture";
      };
      colors = {
        background = theme.bg;
        focused = {
          background = theme.magenta;
          border = theme.magenta;
          childBorder = theme.magenta;
          indicator = theme.magenta;
          text = theme.bg;
        };
        focusedInactive = {
          background = theme.fg-alt;
          border = theme.fg-alt;
          childBorder = theme.mono4;
          indicator = theme.bg;
          text = theme.bg;
        };
        unfocused = {
          background = theme.bg;
          border = theme.magenta;
          childBorder = theme.mono4;
          indicator = theme.bg;
          text = theme.fg-alt;
        };
        urgent = {
          background = theme.red;
          border = theme.red;
          childBorder = theme.red;
          indicator = theme.red;
          text = theme.fg;
        };
      };
    };
  };

  programs.gpg = {
    enable = true;
  };
  
  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
    defaultCacheTtl = 86400;
    defaultCacheTtlSsh = 86400;
    maxCacheTtl = 604800;
    maxCacheTtlSsh = 604800;
  };

  services.dropbox = {
    enable = true;
    path = "${config.home.homeDirectory}/documents";
  };

  systemd.user.services.dropbox.Service.Environment = [
    "HOME=${config.home.homeDirectory}/.dropbox-hm"
    "DISPLAY=:0"
  ];

  home.stateVersion = "21.05";
}
