{ nixpkgs, pkgs, ... }:

{
  nixpkgs.overlays = [
    (import (builtins.fetchTarball {
      # 30/03/2022
      url = https://github.com/nix-community/emacs-overlay/archive/26da73dd9129d267f0c8c26b591ab91050c4cdc9.tar.gz;
    }))
  ];
    
  programs.emacs = {
    enable = true;
    package = pkgs.emacsGcc;
    extraPackages = (epkgs:
      (with epkgs; [
        doom-themes
        eglot
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
        helm
        helm-lsp
        helm-projectile
        direnv
        yasnippet
        prettier-js
        smartparens
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
  
  services.emacs.enable = true;

  home.file = {
    ".emacs.d/init.el" = {
      source = ./init.el;
    };
    ".authinfo.gpg" = {
      source = ./authinfo.gpg;
    };
  };
}
