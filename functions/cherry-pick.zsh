git-extended-cherry-pick() {
  local prev_cmd="echo {} | cut -d' ' -f2 | xargs -I % sh -c 'git show --color=always % | less -R'"
  local prompt_msg1='Select source branch> '
  local prompt_msg2='Pick commits> '

  branch=$(git branch --all | grep -v HEAD | fzf --ansi --reverse --prompt=$prompt_msg1 | sed 's/.* //')

  [ -z $branch ] && return

  selected=$(git log --graph --color=always --format="%C(auto)%h%d %s %C(black)%C(bold)%cr" $branch |
             fzf -m --ansi --no-sort --reverse --prompt=$prompt_msg2 --preview="$prev_cmd" |
             cut -d' ' -f2 |
             tr '\n' ' ')

  [ -z $selected ] && return

  if printf "Cherry pick: $selected. OK?: "; read -q; then
    echo
    git cherry-pick $selected
    echo 'Cherry pick done.'
  fi
}
