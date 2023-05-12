{ config, pkgs, ... }:

let
  comodoro = (import "${config.home.homeDirectory}/code/comodoro").defaultPackage.${builtins.currentSystem};
in
{
  programs.comodoro = {
    enable = true;
    package = comodoro;
    settings = {
      work-began-hook = "${pkgs.libnotify}/bin/notify-send '🍅 Comodoro' 'Working time!'";
      short-break-began-hook = "${pkgs.libnotify}/bin/notify-send '🍅 Comodoro' 'Breaking time!'";
      long-break-began-hook = "${pkgs.libnotify}/bin/notify-send '🍅 Comodoro' 'Long breaking time!'";
      tcp = {
        host = "localhost";
        port = 9999;
      };
    };
  };

  services.comodoro = {
    enable = true;
    environment = {
      RUST_LOG = "debug";
    };
  };
}
