{ config, pkgs, ... }:

let
  himalaya-pkg = pkgs.himalaya.override {
    buildNoDefaultFeatures = true;
    buildFeatures = [ "imap" "maildir" "smtp" "account-sync" "pgp-gpg" ];
  };
in
{
  accounts.email.accounts = {
    posteo = rec {
      primary = true;
      address = "clement.douin@posteo.net";
      realName = "Clément DOUIN";
      userName = address;
      passwordCommand = "${pkgs.pass}/bin/pass show posteo";
      folders = {
        inbox = "INBOX";
        drafts = "Drafts";
        sent = "Sent";
        trash = "Trash";
      };
      imap = {
        tls.enable = true;
        host = "posteo.de";
        port = 993;
      };
      smtp = {
        tls.enable = true;
        host = "posteo.de";
        port = 465;
      };
      himalaya = {
        enable = true;
        settings = {
          folder.sync.filter.include = [ folders.inbox ];
          envelope = {
            list = {
              datetime-fmt = "%d/%m/%Y, %Hh%M";
              datetime-local-tz = true;
            };
            watch = {
              backend = "imap";
              received = {
                cmd = "${himalaya-pkg}/bin/himalaya account sync posteo";
                notify = {
                  summary = "📬 New message from {sender}";
                  body = "{subject}";
                };
              };
            };
          };
          message.send.save-copy = true;
          sync = {
            enable = true;
          };
          pgp.backend = "gpg";
        };
      };
    };
  };

  programs.himalaya = {
    enable = true;
    package = himalaya-pkg;
    settings = {
      signature = "${config.home.homeDirectory}/.signature";
      downloads-dir = "${config.home.homeDirectory}/downloads";
    };
  };

  services.himalaya-watch = {
    enable = true;
    environment = {
      PASSWORD_STORE_DIR = "${config.home.sessionVariables.PASSWORD_STORE_DIR}";
      RUST_LOG = "debug";
    };
    settings = {
      account = "posteo";
    };
  };
}
