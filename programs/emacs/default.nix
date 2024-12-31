{ nixpkgs, pkgs, ... }:

{
  programs.emacs = {
    enable = true;
    package = pkgs.emacs30.override {
      withNativeCompilation = false;
      noGui = true;
      withCsrc = false;
      withDbus = false;
      withGpm = false;
      withImageMagick = false;
      withMailutils = false;
      withSelinux = false;
      withSQLite3 = false;
      withSystemd = false;
      withToolkitScrollBars = false;
      withWebP = false;
      withX = false;
      withSmallJaDic = true;
    };
    extraPackages = (epkgs:
      (with epkgs; [
        doom-themes
        web-mode
        nix-mode
        yaml-mode
        markdown-mode
        rust-mode
        ledger-mode
        typescript-mode
        vimrc-mode
        lua-mode
        direnv
        yasnippet
        prettier-js
        magit
        bbdb
        projectile
        delight
        org
      ]));
  };

  services.emacs = {
    enable = true;
    package = pkgs.emacs29-pgtk;
    startWithUserSession = true;
  };

  home = {
    file = {
      ".emacs.d/init.el" = {
        source = ./init.el;
      };
      ".authinfo.gpg" = {
        source = ./authinfo.gpg;
      };
    };
    sessionVariables = {
      ALTERNATE_EDITOR = "";
      EDITOR = "emacsclient -c";
      VISUAL = "emacsclient -c -a emacs";
    };
  };
}
