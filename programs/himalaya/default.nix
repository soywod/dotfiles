{ config, pkgs, ... }:

let
  himalaya = "${config.home.homeDirectory}/code/himalaya/target/debug/himalaya";
in
{
  accounts.email.accounts.posteo = {
    primary = true;
    realName = "Clément DOUIN";
    userName = "clement.douin@posteo.net";
    address = "clement.douin@posteo.net";
    passwordCommand = "pass show posteo";
    imap = {
      host = "posteo.de";
      port = 993;
    };
    smtp = {
      host = "posteo.de";
      port = 465;
    };
    himalaya = {
      enable = true;
      settings = {
        signature = "~/.signature";
        pgp-encrypt-cmd = "gpg -o - -eqar";
        pgp-decrypt-cmd = "gpg -dq";
        watch-cmds = [
          "${himalaya} -o json search not seen | ${pkgs.jq}/bin/jq -r '.response|length' >> /tmp/himalaya-counter"
        ];
      };
    };
  };
  
  programs.himalaya = {
    enable = true;
    settings = {
      downloads-dir = "${config.home.homeDirectory}/downloads";
    };
  };

  systemd.user.services.himalaya = {
    Unit = {
      Description = "Himalaya watcher.";
    };
    Install = {
      WantedBy = [ "multi-user.target" ];
    };
    Service = {
      ExecStart = "${himalaya} watch";
      Restart = "always";
      RestartSec = 10;
    };
  };
}
