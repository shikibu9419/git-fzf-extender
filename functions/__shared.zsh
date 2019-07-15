__git_extended::init() {
  GREEN='\033[32m'
  YELLOW='\033[33m'
  BLUE='\033[34m'
  MAGENTA='\033[35m'
  BOLD='\033[1m'
  DEFAULT='\033[m'

  FZF='fzf --ansi --no-sort --reverse'
  FZF_TMUX='fzf-tmux --ansi --no-sort -d'
  GIT_ROOT=$(git rev-parse --show-cdup)
  TEMPLATE_ROOT=$GIT_ROOT.github

  __git_extended::check-available
}

__git_extended::check-available() {
  git rev-parse > /dev/null 2>&1 &&
    type 'fzf' > /dev/null 2>&1 &&
    type 'hub' > /dev/null 2>&1
}

__git_extended::error() {
  echo 'ERROR MESSAGE'
}
