git-extended-stash() {
  __git_extended::init || return 1

  local prev_cmd="echo {} | cut -d: -f1 | xargs -I % git stash show % -p --color"

  selected=$(git stash list |
             cut -d' ' -f1,6- |
             $=FZF --preview=$prev_cmd |
             cut -d' ' -f1 | cut -d: -f1)

  if printf "Apply: $selected. OK?: "; read -q; then
    echo
    git stash apply $selected
    echo 'Apply done.'
  fi
}
