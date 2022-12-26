{ config, lib, nixpkgs, pkgs, ... }:

let
  theme = import ./theme.nix;
  tex = (pkgs.texlive.combine {
    inherit (pkgs.texlive) scheme-small
      # french language
      collection-langfrench
      # org-mode invoice pdf export
      wrapfig lastpage capt-of
      # number formatting
      siunitx;
  });

in
{
  nixpkgs.config.allowUnfree = true;

  imports = [
    (import ./programs/bash { inherit pkgs; })
    (import ./programs/dunst { inherit pkgs config theme; })
    (import ./programs/ergodox { inherit pkgs; })
    (import ./programs/direnv { inherit pkgs; })
    (import ./programs/emacs { inherit nixpkgs pkgs; })
    (import ./programs/himalaya { inherit pkgs config; })
  ];

  home = {
    packages = with pkgs; [
      brightnessctl
      chromium
      element-desktop
      filezilla
      ghostscript
      gimp
      inkscape
      ledger
      libnotify
      libreoffice
      mpv
      p7zip
      postman
      pavucontrol
      pulseaudio
      ripgrep
      tdesktop
      tex
      w3m
      wally-cli
      xdg-utils
      xournal
    ];
    sessionPath = [
      "${config.home.homeDirectory}/.local/bin"
    ];
    sessionVariables = {
      EDITOR = "editor";
      VISUAL = "editor";
      PASSWORD_STORE_DIR = "${config.home.homeDirectory}/documents/password-store";
      MOZ_ENABLE_WAYLAND = "1";
      XDG_CURRENT_DESKTOP = "sway";
      XDG_SESSION_TYPE = "wayland";
    };
    file = {
      ".signature".text = ''
        Cordialement
        Clément DOUIN
        Développeur Web Full-Stack
        https://soywod.me
      '';
      ".ledgerrc".text = ''
        --file ${config.home.homeDirectory}/documents/ledger/auto-entrepreneur.ldg
        --strict
        --empty
      '';
    };
  };

  programs.home-manager = {
    enable = true;
  };

  programs.browserpass = {
    enable = true;
    browsers = [ "chromium" ];
  };

  programs.waybar = {
    enable = true;
    systemd.enable = true;
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
          "custom/himalaya"
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
            format-icons = [ "" "" "" "" "" ];
          };
          temperature = {
            interval = 1;
            tooltip = false;
            thermal-zone = 1;
            critical-threshold = 80;
            format = "{icon} {temperatureC}°C";
            format-critical = "{icon} {temperatureC}°C";
            format-icons = [ "" "" "" "" "" ];
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
              default = [ "" "" ];
            };
          };

          "custom/himalaya" = {
            exec = "${pkgs.coreutils}/bin/tail -fn 1 /tmp/himalaya-counter";
            format = "{} ";
            tooltip = false;
          };
          clock = {
            timezone = "Europe/Paris";
            tooltip = false;
            format = "{:%Hh%M, %a %e %b}";
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
        font-size: 1.1rem;
        font-weight: bold;
      }
      
      #waybar {
        background-color: ${theme.fg};
        color: ${theme.bg};
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
        color: ${theme.green};
      }
      
      #battery.warning {
        color: ${theme.orange};
      }
      
      .critical {
        background-color: ${theme.red};
        color: ${theme.fg};
      }
      
      #battery.charging {
        color: ${theme.blue};
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
    lfs.enable = true;
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

  gtk = {
    enable = true;
    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = true;
    };
  };

  programs.kitty = {
    enable = true;
    settings = {
      confirm_os_window_close = 0;
      font_family = "JetBrains Mono";
      font_size = 15;
      cursor_blink_interval = 1;
      sync_to_monitor = false;
      linux_display_server = "wayland";
      background_opacity = 90;
      touch_scroll_multiplier = 10;
      background = theme.bg;
      foreground = theme.fg;
      selection_background = theme.mono4;
      selection_foreground = theme.fg;
      cursor = theme.blue;
      url_color = theme.dark-blue;
      color0 = theme.mono4;
      color1 = theme.red;
      color2 = theme.green;
      color3 = theme.yellow;
      color4 = theme.blue;
      color5 = theme.magenta;
      color6 = theme.cyan;
      color7 = theme.fg;
      color8 = theme.mono4;
      color9 = theme.red;
      color10 = theme.green;
      color11 = theme.yellow;
      color12 = theme.blue;
      color13 = theme.magenta;
      color14 = theme.cyan;
      color15 = theme.fg;
    };
    keybindings = {
      "ctrl+shift+n" = "new_os_window_with_cwd";
    };
  };

  wayland.windowManager.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
    config = {
      menu = "${pkgs.dmenu}/bin/dmenu_path | ${pkgs.dmenu}/bin/dmenu -b -fn JetBrainsMono-15 -nb '${theme.bg}' -nf '${theme.fg}' -sb '${theme.blue}' -sf '${theme.bg}' | ${pkgs.findutils}/bin/xargs swaymsg exec --";
      modifier = "Mod4";
      terminal = "kitty";
      focus.followMouse = false;
      gaps.inner = 16;
      window.border = 2;
      floating.border = 2;
      bars = [ ];
      fonts = {
        names = [ "JetBrains Mono" ];
        style = "Medium";
        size = 12.0;
      };
      input = {
        "type:keyboard" = {
          xkb_layout = "us,ru";
          xkb_variant = "dvorak-alt-intl,";
          xkb_options = "grp:shifts_toggle,numpad:mac,compose:ralt,ctrl:swapcaps";
          repeat_delay = "256";
          repeat_rate = "32";
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
          bg = "${config.home.homeDirectory}/documents/wallpapers/nixos.svg fill";
        };
        DP-2 = {
          resolution = "1920x1080@60Hz";
          position = "1920 0";
          bg = "${config.home.homeDirectory}/documents/wallpapers/nixos.svg fill";
        };
      };
      keybindings =
        let
          mod = config.wayland.windowManager.sway.config.modifier;
        in
        lib.mkOptionDefault {
          "${mod}+Tab" = "workspace back_and_forth";

          "XF86MonBrightnessDown" = "exec brightnessctl set 5%-";
          "Shift+XF86MonBrightnessDown" = "exec brightnessctl set 1%";
          "Shift+${mod}+XF86MonBrightnessDown" = "exec brightnessctl set 1%-";

          "XF86MonBrightnessUp" = "exec brightnessctl set  5%+";
          "Shift+XF86MonBrightnessUp" = "exec brightnessctl set 100%";
          "Shift+${mod}+XF86MonBrightnessUp" = "exec brightnessctl set  1%+";

          "XF86AudioLowerVolume" = "exec pactl set-sink-volume @DEFAULT_SINK@ -5%";
          "Shift+XF86AudioLowerVolume" = "exec pactl set-sink-volume @DEFAULT_SINK@  1%";
          "Shift+${mod}+XF86AudioLowerVolume" = "exec pactl set-sink-volume @DEFAULT_SINK@ -1%";

          "XF86AudioRaiseVolume" = "exec pactl set-sink-volume @DEFAULT_SINK@ +5%";
          "Shift+XF86AudioRaiseVolume" = "exec pactl set-sink-volume @DEFAULT_SINK@ 100%";
          "Shift+${mod}+XF86AudioRaiseVolume" = "exec pactl set-sink-volume @DEFAULT_SINK@ +1%";

          "XF86AudioMute" = "exec pactl set-sink-mute   @DEFAULT_SINK@ toggle";
          "XF86AudioMicMute" = "exec pactl set-source-mute @DEFAULT_SINK@ toggle";

          "XF86AudioPrev" = "exec playerctl previous";
          "XF86AudioPlay" = "exec playerctl play-pause";
          "XF86AudioNext" = "exec playerctl next";

          "Print" = "exec selection-capture";
          "Shift+Print" = "exec selection-record";
          "Shift+${mod}+Print" = "exec screen-capture";
        };
      colors = {
        background = theme.bg;
        focused = {
          background = theme.blue;
          border = theme.blue;
          childBorder = theme.mono2;
          indicator = theme.blue;
          text = theme.bg;
        };
        focusedInactive = {
          background = theme.dark-blue;
          border = theme.blue;
          childBorder = theme.mono2;
          indicator = theme.dark-blue;
          text = theme.bg;
        };
        unfocused = {
          background = theme.mono2;
          border = theme.mono2;
          childBorder = theme.mono2;
          indicator = theme.fg;
          text = theme.fg;
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
    extraConfig = ''
      titlebar_border_thickness 2
    '';
  };

  programs.gpg = {
    enable = true;
  };

  programs.password-store = {
    enable = true;
    settings = {
      PASSWORD_STORE_DIR = "${config.home.homeDirectory}/documents/password-store";
    };
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

  systemd.user.services.dropbox = {
    Unit.After = "graphical-session.target network-online.target";
    Service.Environment = [ "DISPLAY=:0" ];
  };

  services.gammastep = {
    enable = true;
    tray = true;
    provider = "geoclue2";
    settings = {
      general = {
        fade = false;
      };
    };
  };

  home.stateVersion = "21.05";
}
