{ pkgs, ... }:

let
  bash-git-prompt = pkgs.fetchFromGitHub {
    owner = "magicmonty";
    repo = "bash-git-prompt";
    rev = "148d502b666a0d62ecc83680817596b097a70f2a";
    sha256 = "0xdyyc0lvfrxg9bgmiy4h22y0wp6x3yn6md6jy2f7kcw8dww9pyz";
  };
in {    
  home = {
    packages = with pkgs; [
      slurp
      grim
      wf-recorder
      wl-clipboard
    ];
    file = {
      ".local/bin/screen-capture" = {
        source = ./screen-capture.sh;
      };
      ".local/bin/selection-capture" = {
        source = ./selection-capture.sh;
      };
      ".local/bin/selection-record" = {
        source = ./selection-record.sh;
      };
    };
  };

  programs.bash = {
    enable = true;
    historySize = -1;
    historyFileSize = -1;
    historyControl = ["erasedups"];
    historyIgnore = ["ls" "cd" "exit" "emacs"];
    shellOptions = ["histappend" "checkwinsize" "extglob" "globstar" "checkjobs" "cdspell"];
    shellAliases = {
      dc="docker-compose";
      ga="git add";
      gcam="git commit --amend --no-edit";
      gcams="gcam -S";
      gcm="git commit -m";
      gcms="git commit -S -m";
      gco="git checkout";
      gd="git diff";
      glog="git log --oneline --decorate --graph";
      gpull="git pull origin $(git rev-parse --abbrev-ref HEAD)";
      gpush="git push origin $(git rev-parse --abbrev-ref HEAD)";
      gfpush="gpush --force-with-lease";
      gss="git status";
      grm="git pull origin master --rebase";
      u="unfog";
      h="himalaya";
      o="xdg-open";
    };
    profileExtra = ''      
      if [ "$(tty)" == "/dev/tty1" ] && [ -z "$WAYLAND_DISPLAY" ] && command -v sway >/dev/null
      then
        systemctl --user start graphical-session.target
        exec sway
      fi
    '';
    initExtra = ''
      source "${bash-git-prompt}/gitprompt.sh"
    '';
  };
}
