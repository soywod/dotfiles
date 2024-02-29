{ nixpkgs, pkgs, ... }:

{
  programs.emacs = {
    enable = true;
    package = pkgs.emacs29-pgtk;
    extraPackages = (epkgs:
      (with epkgs; [
        doom-themes
        web-mode
        nix-mode
        yaml-mode
        markdown-mode
        rust-mode
        ledger-mode
        graphql-mode
        typescript-mode
        vimrc-mode
        lua-mode
        direnv
        yasnippet
        prettier-js
        # smartparens
        magit
        bbdb
        projectile
        which-key
        pass
        delight
        expand-region
        org
        tree-sitter
        tree-sitter-langs
        rg
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
