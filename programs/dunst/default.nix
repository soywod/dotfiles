{ pkgs, theme, config }:

let
  notification = "${config.xdg.dataHome}/dunst/notification.ogg";
  notifier = pkgs.writeShellScriptBin "notify" ''
    ${pkgs.mpv}/bin/mpv --really-quiet ${notification}
  '';

in
{
  home = {
    packages = [ notifier ];
    file."${notification}".source = ./notification.ogg;
  };

  services.dunst = {
    enable = true;
    settings = {
      global = {
        monitor = 0;
        follow = "mouse";
        width = "(300, 500)";
        origin = "bottom-right";
        offset = "16x16";
        scale = 0;
        notification_limit = 0;
        progress_bar = true;
        progress_bar_height = 10;
        progress_bar_frame_width = 1;
        progress_bar_min_width = 150;
        progress_bar_max_width = 300;
        indicate_hidden = true;
        transparency = 0;
        separator_height = 2;
        padding = 8;
        horizontal_padding = 8;
        text_icon_padding = 0;
        frame_width = 3;
        frame_color = "#c678dd";
        separator_color = "frame";
        sort = true;
        font = "JetBrains Mono 12";
        line_height = 0;
        markup = "full";
        format = "<b>%s</b>\n%b";
        alignment = "left";
        vertical_alignment = "top";
        show_age_threshold = 60;
        ellipsize = "middle";
        ignore_newline = false;
        stack_duplicates = true;
        hide_duplicate_count = false;
        show_indicators = true;
        icon_position = "left";
        min_icon_size = 0;
        max_icon_size = 64;
        icon_path = "/usr/share/icons/gnome/16x16/status/:/usr/share/icons/gnome/16x16/devices/";
        sticky_history = false;
        history_length = 20;
        dmenu = "/usr/bin/dmenu -p dunst";
        browser = "/usr/bin/xdg-open";
        always_run_script = true;
        title = "Dunst";
        class = "Dunst";
        corner_radius = 0;
        ignore_dbusclose = false;
        force_xwayland = false;
        force_xinerama = false;
        mouse_left_click = [ "close_current" ];
        mouse_middle_click = [ "do_action" "close_current" ];
        mouse_right_click = [ "close_all" ];
      };
      experimental = {
        per_monitor_dpi = false;
      };
      urgency_low = {
        background = theme.dark-blue;
        foreground = theme.fg;
        frame_color = theme.blue;
        timeout = 10;
      };
      urgency_normal = {
        background = theme.dark-blue;
        foreground = theme.fg;
        frame_color = theme.blue;
        timeout = 10;
      };
      urgency_critical = {
        background = theme.orange;
        foreground = theme.fg;
        frame_color = theme.red;
        timeout = 0;
      };
      all = {
        summary = "*";
        script = "${notifier}/bin/notify";
      };
    };
  };
}
