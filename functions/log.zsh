git-extended-log() {
  __git_extended::init || { __git_extended::error; return 1 }

  local prev_cmd="echo {} | cut -d' ' -f2 | xargs git show --color=always | less -R"

  git log --graph --color=always --format="%C(auto)%h%d %s %C(black)%C(bold)%cr" $@ |
    $=FZF --tiebreak=index --preview="$prev_cmd" --bind "ctrl-m:execute: $prev_cmd"
}
