__git_extended::check_available() {
  git rev-parse > /dev/null 2>&1
}

__git_extended::fzf() {
  fzf-tmux -d --ansi --no-sort --prompt="$1> " ${@:2-}
}

__git_extended::fzf-with-preview() {
  fzf ansi --no-sort --prompt="$1> " --preview="$2" ${@:3-}
}

__git_extended::init() {
  GREEN='\033[32m'
  YELLOW='\033[33m'
  BLUE='\033[34m'
  MAGENTA='\033[35m'
  BOLD='\033[1m'
  DEFAULT='\033[m'
}
