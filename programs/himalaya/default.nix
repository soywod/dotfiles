{ config, pkgs, ... }:

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
          envelope.watch = {
            backend = "imap";
            received.notify = {
              summary = "📬 New message from {sender}";
              body = "{subject}";
            };
          };
          message.send.save-copy = true;
          sync = {
            enable = true;
            strategy.include = [ folders.inbox ];
          };
          pgp.backend = "gpg";
        };
      };
    };
  };

  programs.himalaya = {
    enable = true;
    package = pkgs.himalaya.override { buildFeatures = [ "pgp-gpg" "pgp-commands" ]; };
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
  };
}
