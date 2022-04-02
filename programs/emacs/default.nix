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
        flx
        rust-mode
        ledger-mode
        company
        direnv
        yasnippet
        prettier-js
        smartparens
        magit
        bbdb
        projectile
        ivy
        counsel
        counsel-projectile
        swiper
        which-key
        pass
        delight
        yaml-mode
        markdown-mode
        expand-region
        org
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
