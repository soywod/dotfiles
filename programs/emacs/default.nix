{ ... }:

{
  services.emacs.enable = true;
  programs.emacs = {
    enable = true;
    extraPackages = (epkgs:
      (with epkgs; [
        melpaPackages.use-package
        melpaPackages.doom-themes
        melpaPackages.nix-mode
        melpaPackages.lsp-mode
        melpaPackages.typescript-mode
        melpaPackages.rust-mode
        melpaPackages.smartparens
        melpaPackages.magit
        melpaPackages.bbdb
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
