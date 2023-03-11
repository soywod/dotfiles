{ config, pkgs, ... }:

let
  himalaya = (import "${config.home.homeDirectory}/code/himalaya").defaultPackage.${builtins.currentSystem};
in
{
  accounts.email.accounts = {
    posteo = {
      primary = true;
      realName = "Clément DOUIN";
      userName = "clement.douin@posteo.net";
      address = "clement.douin@posteo.net";
      passwordCommand = "${pkgs.pass}/bin/pass show posteo";
      folders = {
        inbox = "INBOX";
        drafts = "Drafts";
        sent = "Sent";
        trash = "Trash";
      };
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
          sync = true;
          email-writing-encrypt-cmd = "gpg -o - -eqar <recipient>";
          email-reading-decrypt-cmd = "gpg -dq";
          imap-notify-cmd = ''
            ${pkgs.libnotify}/bin/notify-send "📫 <sender>" "<subject>"
          '';
        };
      };
    };

    gmail = {
      realName = "Clément DOUIN";
      userName = "clement@getpiana.com";
      address = "clement@getpiana.com";
      passwordCommand = "${pkgs.pass}/bin/pass show piana/gmail";
      folders = {
        inbox = "INBOX";
        drafts = "[Gmail]/Drafts";
        sent = "[Gmail]/Sent Mail";
        trash = "[Gmail]/Trash";
      };
      imap = {
        host = "imap.gmail.com";
        port = 993;
      };
      smtp = {
        host = "smtp.gmail.com";
        port = 465;
      };
      himalaya = {
        enable = true;
        settings = {
          sync = true;
        };
      };
    };
  };

  programs.himalaya = {
    enable = true;
    package = himalaya;
    settings = {
      signature = "~/.signature";
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
}
