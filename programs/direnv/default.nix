{ pkgs, ... }:

{
  programs.direnv = {
    enable = true;
    enableZshIntegration = false;
    enableFishIntegration = false;
    nix-direnv = {
      enable = true;
      enableFlakes = true;
    };
  };
}
