git-extended-diff() {
  __git_extended::init || return 1

  selected=$(__git_extended::diff \
             'SELECT FILES> '     \
             'echo {} | cut -c4- | xargs git diff --color' \
             $@)

  [[ -z $selected ]] && return 0

  echo "selected: $selected"
}

__git_extended::diff() {
  __git_extended::init || { __git_extended::error; return 1 }

  local prompt_msg=$1
  local prev_cmd=$2
  local args=${@:3}

  local diff_cmd='git status --short'
  [[ -n "$args" ]] && diff_cmd="git diff --name-status $args"

  ## TODO: change tab to 2 spaces
  ## TODO: fix mistery escape sequences
  selected=$(git add -N -A; unbuffer $=diff_cmd |
             $=FZF -m --prompt=$prompt_msg --preview=$prev_cmd |
             cut -c4- | tr '\n' ' ')

  git reset --quiet $(git status -s | grep ' A ' | cut -c4-)

  echo $selected
}
