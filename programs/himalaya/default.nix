{ config, ... }:

{
  programs.himalaya = {
    enable = true;
    settings = {
      downloads-dir = "${config.home.homeDirectory}/downloads";
    };
  };

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
      };
    };
  };
}
