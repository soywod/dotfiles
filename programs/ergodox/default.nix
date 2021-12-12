{ pkgs, ... }:

{    
  home.packages = with pkgs; [
    # Tool for flashing ErgoDox EZ keyboard
    wally-cli
  ];
}
