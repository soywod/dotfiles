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
    passwordCommand = "${pkgs.pass}/bin/pass show posteo";
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
        email-writing-encrypt-cmd = "gpg -o - -eqar <recipient>";
        email-reading-decrypt-cmd = "gpg -dq";
        imap-notify-cmd = "${pkgs.libnotify}/bin/notify-send";
        imap-watch-cmds = [
          "${himalaya} -o json search not seen | ${pkgs.jq}/bin/jq -r 'if (.|length)>0 then \"\" else \"\" end' >> /tmp/himalaya-counter"
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

  services.himalaya-notify = {
    enable = true;
    environment = {
      PASSWORD_STORE_DIR = "${config.home.sessionVariables.PASSWORD_STORE_DIR}";
      RUST_LOG = "debug";
    };
  };

  services.himalaya-watch = {
    enable = true;
    environment = {
      PASSWORD_STORE_DIR = "${config.home.sessionVariables.PASSWORD_STORE_DIR}";
      RUST_LOG = "debug";
    };
  };
}
