{ nixpkgs, pkgs, ... }:

{
  nixpkgs.overlays = [
    (import (builtins.fetchTarball {
      # 28/01/2024
      url = https://github.com/nix-community/emacs-overlay/archive/d6d5dd09b6533a30e3b312f0f225bd3475733f23.tar.gz;
    }))
  ];

  programs.emacs = {
    enable = true;
    package = pkgs.emacs-pgtk;
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
    package = pkgs.emacs-pgtk;
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
