git-extended-add() {
  selected=$(git add -N -A; git status -s |
             fzf -m --ansi --preview="echo {} | cut -d' ' -f3 | xargs git diff --color" |
             cut -d' ' -f3 |
             tr '\n' ' ')

  [ -z $selected ] && return 0

  git add $@ $=selected
  echo "Added: $selected"
}
