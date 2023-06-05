{ config, pkgs, ... }:

let
  comodoro = (import "${config.home.homeDirectory}/code/comodoro").packages.${builtins.currentSystem}.default;
  notify = desc: "${pkgs.libnotify}/bin/notify-send '🍅 Comodoro' '${desc}'";
in
{
  programs.comodoro = {
    enable = true;
    package = comodoro;
    settings = {
      work = {
        preset = "52/17";

        tcp-host = "localhost";
        tcp-port = 9999;

        on-work-begin = notify "Work time!";
        on-resting-begin = notify "Rest time!";
      };
    };
  };

  services.comodoro = {
    enable = true;
    settings = {
      preset = "work";
      protocols = [ "tcp" ];
    };
    environment = {
      RUST_LOG = "debug";
    };
  };
}
