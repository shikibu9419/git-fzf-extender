git-extended-stash() {
  selected=$(git stash list |
             cut -d' ' -f1,6- |
             fzf --reverse --ansi \
               --preview="echo {} | cut -d: -f1 | xargs -I % git stash show % -p --color" |
             cut -d' ' -f1 | cut -d: -f1)

  if printf "Apply: $selected. OK?: "; read -q; then
    git stash apply $selected
    echo 'Done.'
  fi
}
