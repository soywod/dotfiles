{ nixpkgs, pkgs, ... }:

{
  programs.emacs = {
    enable = true;
    package = pkgs.emacs30.override {
      noGui = true;
      withCsrc = false;
      withDbus = false;
      withGpm = false;
      withImageMagick = false;
      withMailutils = false;
      withNativeCompilation = false;
      withSQLite3 = false;
      withSelinux = false;
      withSmallJaDic = true;
      withSystemd = false;
      withToolkitScrollBars = false;
      withWebP = false;
      withX = false;
    };
    extraPackages = (epkgs:
      (with epkgs; [
        bbdb
        delight
        direnv
        doom-themes
        ledger-mode
        lua-mode
        magit
        markdown-ts-mode
        nix-mode
        org
        prettier-js
        projectile
        rg
        rust-mode
        tree-sitter
        tree-sitter-langs
        typescript-mode
        vimrc-mode
        web-mode
        yaml-mode
        yasnippet
      ]));
  };

  services.emacs = {
    enable = true;
    package = pkgs.emacs30-pgtk;
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
