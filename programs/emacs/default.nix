{ nixpkgs, pkgs, ... }:

{
  nixpkgs.overlays =
    let
      emacs-rev = "5f9bc90bd2fd0bf53cc4e2643b083fa75b358461"; # 04/05/2023
      emacs-tarball = "https://github.com/nix-community/emacs-overlay/archive/${emacs-rev}.tar.gz";
      emacs-overlay = import "${builtins.fetchTarball emacs-tarball}";
    in
    [ emacs-overlay ];

  programs.emacs = {
    enable = true;
    package = pkgs.emacsUnstable;
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

  services.emacs = {
    enable = true;
    package = pkgs.emacsUnstable;
    startWithUserSession = true;
    defaultEditor = true;
  };

  home.file = {
    ".emacs.d/init.el" = {
      source = ./init.el;
    };
    ".authinfo.gpg" = {
      source = ./authinfo.gpg;
    };
  };
}
