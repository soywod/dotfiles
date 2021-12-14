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
        company
        yasnippet
        add-node-modules-path
        prettier-js
        smartparens
        magit
        bbdb
        elpaPackages.org
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
