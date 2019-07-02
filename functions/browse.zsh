git-extended-browse() {
  __git_extended::init || __git_extended::error && return 1
  selected=$(ghq list | $=FZF_TMUX -m | tr '\n' ' ')

  for dir in $=selected; do
    repo=${dir#*/}
    hub browse $repo
  done
}
