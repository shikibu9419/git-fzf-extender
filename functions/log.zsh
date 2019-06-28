git-extended-log() {
  local prev_cmd="echo {} | cut -d' ' -f2 | xargs -I % sh -c 'git show --color=always % | less -R'"

  git log --graph --color=always --format="%C(auto)%h%d %s %C(black)%C(bold)%cr" $@ |
    fzf --ansi --no-sort --reverse --tiebreak=index \
        --bind "ctrl-m:execute: $prev_cmd" \
        --preview="$prev_cmd"
}
