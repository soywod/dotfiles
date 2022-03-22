{ ... }:

{
  services.emacs.enable = true;
  programs.emacs = {
    enable = true;
    extraPackages = (epkgs:
      (with epkgs; [
        use-package
        doom-themes
        lsp-mode
        web-mode
        nix-mode
        rust-mode
        ledger-mode
        emmet-mode
        direnv
        yasnippet
        prettier-js
        smartparens
        magit
        bbdb
        projectile
        helm
        helm-lsp
        helm-projectile
        helm-rg
        which-key
        pass
        delight
        yaml-mode
        expand-region
        org
      ]));
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
