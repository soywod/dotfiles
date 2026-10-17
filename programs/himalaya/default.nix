{
  config,
  himalaya,
  pkgs,
}:

{
  accounts.email.accounts.posteo = {
    primary = true;
    flavor = "posteo.de";
    address = "clement.douin@posteo.net";
    realName = "Clément DOUIN";
    passwordCommand = "${config.programs.password-store.package}/bin/pass show posteo";
    imap.authentication = "plain";
    smtp.authentication = "plain";
    himalaya.enable = true;
  };

  programs.himalaya = {
    enable = true;
    package = himalaya.packages.${pkgs.stdenv.hostPlatform.system}.default;
  };
}
