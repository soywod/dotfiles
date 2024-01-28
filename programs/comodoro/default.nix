{ config, pkgs, ... }:

let
  notify = desc: "${pkgs.libnotify}/bin/notify-send '🍅 Comodoro' '${desc}'";
in
{
  programs.comodoro = {
    enable = true;
    settings = {
      work = {
        cycles = [
          {
            name = "Work";
            duration = 75 * 60;
          }
          {
            name = "Rest";
            duration = 10 * 60;
          }
        ];

        tcp-host = "localhost";
        tcp-port = 9999;

        on-work-begin = notify "Work time!";
        on-rest-begin = notify "Rest time!";
      };
    };
  };

  services.comodoro = {
    enable = true;
    preset = "work";
    protocols = [ "tcp" ];
    environment = {
      RUST_LOG = "debug";
    };
  };
}
