git-extended-browse() {
  selected=$(ghq list | fzf-tmux -m | tr '\n' ' ')

  for dir in $=selected; do
    repo=${dir#*/}
    hub browse $repo
  done
}
