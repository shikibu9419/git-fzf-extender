__git_extended::init() {
  GREEN='\033[32m'
  YELLOW='\033[33m'
  BLUE='\033[34m'
  MAGENTA='\033[35m'
  BOLD='\033[1m'
  DEFAULT='\033[m'

  FZF='fzf --ansi --no-sort --reverse'
  FZF_TMUX='fzf-tmux --ansi --no-sort -d'

  git rev-parse > /dev/null 2>&1 &&
    __git_extended::check-availability
}

__git_extended::check-availability() {
  type 'fzf' > /dev/null 2>&1 &&
  type 'hub' > /dev/null 2>&1 ||
  __git_extended::error 'Some dependencies are not available.'
}

__git_extended::error() {
  echo "git-extended ERROR: $1"
  return 1
}
