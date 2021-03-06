git-extended-add() {
  __git_extended::init || return 1

  local prompt_msg="SELECT FILES> "
  local prev_cmd="echo {} | cut -d' ' -f3 | xargs git diff --color"

  selected=$(git add -N -A; unbuffer git status -s |
             $=FZF -m --prompt=$prompt_msg --preview=$prev_cmd |
             cut -d' ' -f3 |
             tr '\n' ' ')

  [[ -z $selected ]] && return 0

  git add $@ $=selected
  echo "Added: $selected"
}
