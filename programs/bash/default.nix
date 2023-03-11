{ pkgs, ... }:

let
  bash-git-prompt = pkgs.fetchFromGitHub {
    owner = "magicmonty";
    repo = "bash-git-prompt";
    rev = "148d502b666a0d62ecc83680817596b097a70f2a";
    sha256 = "0xdyyc0lvfrxg9bgmiy4h22y0wp6x3yn6md6jy2f7kcw8dww9pyz";
  };
in
{
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
    sessionVariables = {
      GIT_PROMPT_FETCH_REMOTE_STATUS = 0;
      GIT_PROMPT_IGNORE_SUBMODULES = 1;
      GIT_PROMPT_WITH_VIRTUAL_ENV = 0;
      GIT_PROMPT_SHOW_UNTRACKED_FILES = "no";
      GIT_PROMPT_START = "_LAST_COMMAND_INDICATOR_ \\[\\e[36m\\]\\W\\[\\e[m\\]";
      GIT_PROMPT_END = " \\[\\e[\\$(case \\$IN_NIX_SHELL in pure) echo 36;; impure) echo 33;; *) echo 31;; esac)m\\]➜\\[\\e[m\\] ";
      GIT_PROMPT_COMMAND_OK = "";
    };
  };

  programs.bash = {
    enable = true;
    historySize = -1;
    historyFileSize = -1;
    historyControl = [ "erasedups" ];
    historyIgnore = [ "ls" "cd" "exit" "emacs" ];
    shellOptions = [ "histappend" "checkwinsize" "extglob" "globstar" "checkjobs" "cdspell" ];
    shellAliases = {
      dc = "docker-compose";
      ga = "git add";
      gcam = "git commit --amend --no-edit";
      gcams = "gcam -S";
      gcm = "git commit -m";
      gcms = "git commit -S -m";
      gco = "git checkout";
      gd = "git diff";
      glog = "git log --oneline --decorate --graph";
      gpull = "git pull origin $(git rev-parse --abbrev-ref HEAD)";
      gpush = "git push origin $(git rev-parse --abbrev-ref HEAD)";
      gfpush = "gpush --force-with-lease";
      gss = "git status";
      grm = "git pull origin master --rebase";
      u = "unfog";
      h = "~/code/himalaya/target/debug/himalaya";
      o = "xdg-open";
      l = ''ledger --strict --empty --input-date-format="%d/%m/%y" --effective --cleared --file ~/documents/ledger/auto-entrepreneur.ldg'';
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
