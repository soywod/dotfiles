{ config, lib, nixpkgs, pkgs, ... }:

let
  theme = import ./theme.nix;
  tex = (pkgs.texlive.combine {
    inherit (pkgs.texlive) scheme-small
      collection-langfrench # french language
      wrapfig lastpage; # org-mode invoice pdf export
  });
  slack = pkgs.slack.overrideAttrs (old: {
    installPhase = old.installPhase + ''
      rm $out/bin/slack

      makeWrapper $out/lib/slack/slack $out/bin/slack \
        --prefix XDG_DATA_DIRS : $GSETTINGS_SCHEMAS_PATH \
        --prefix PATH : ${lib.makeBinPath [pkgs.xdg-utils]} \
        --add-flags "--enable-features=WebRTCPipeWireCapturer"
    '';
  });
  
in
{
  nixpkgs.config.allowUnfree = true;

  nixpkgs.overlays = [
    # For neovim nightly:
    # (import (builtins.fetchTarball {
    #   url = https://github.com/nix-community/neovim-nightly-overlay/archive/master.tar.gz;
    # }))
  ];

  imports = [
    (import ./programs/bash { inherit pkgs; })
    (import ./programs/dunst { inherit config pkgs; })
    (import ./programs/ergodox { inherit pkgs; })
    (import ./programs/direnv { inherit pkgs; })
    (import ./programs/emacs { inherit nixpkgs pkgs; })
    (import ./programs/himalaya { inherit config pkgs; })
  ];

  home = {
    packages = with pkgs; [
      chromium
      libreoffice
      brightnessctl
      pulseaudio
      ghostscript
      p7zip
      ripgrep
      mpv
      xdg-utils
      gimp
      inkscape
      tdesktop
      wally-cli
      ledger
      libnotify
      w3m
      tex
      xournal
      filezilla
      slack
      postman
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

  programs.firefox = {
    enable = true;
    package = pkgs.wrapFirefox pkgs.firefox-unwrapped {
      forceWayland = true;
      extraNativeMessagingHosts = [ pkgs.passff-host ];
      extraPolicies = {
        ExtensionSettings = { };
      };
    };
  };

  programs.home-manager = {
    enable = true;
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
            exec = "${pkgs.coreutils}/bin/tail -fn 1 /tmp/himalaya-counter | ${pkgs.findutils}/bin/xargs -I {} ${pkgs.bash}/bin/bash -c 'if [ {} -gt 0 ]; then echo ; else echo; fi'";
            format = "{} ";
            tooltip = false;
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
        font-weight: bold;
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
      bars = [];
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

  programs.neovim = {
    enable = true;
    # For neovim nightly:
    # package = pkgs.neovim-nightly;
    viAlias = true;
    vimAlias = true;
    plugins = [ pkgs.vimPlugins.telescope-nvim ];
    extraConfig = ''
      set runtimepath+=,~/code/himalaya/vim
      let g:himalaya_telescope_preview_enabled = 0
      let g:himalaya_mailbox_picker = "native"
    '';
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
    Service.Environment = ["DISPLAY=:0"];
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
