git-extended-add() {
  local prev_cmd="echo {} | cut -d' ' -f3 | xargs git diff --color"
  local prompt_msg="Select files you wanna stage> "

  selected=$(git add -N -A; git status -s |
             fzf -m --ansi --prompt=$prompt_msg --preview=$prev_cmd |
             cut -d' ' -f3 |
             tr '\n' ' ')

  [ -z $selected ] && return 0

  git add $@ $=selected
  echo "Added: $selected"
}
