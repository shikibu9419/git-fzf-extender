git-extended-grep() {
  __git_extended::init || { __git_extended::error; return 1 }

  [[ -z $1 ]] && return
  prev_cmd="set {}; highlight --force -O ansi -n {1} | grep --color=always -e $ -e $1"

  files=$(git grep --max-depth 1 -n $1 | cut -d: -f1,2 | sed 's/:/ - /' |
          $=FZF -m --preview=$prev_cmd |
          cut -d' ' -f1 | sort | uniq | tr '\n' ' ')

  [[ -z $files ]] && return
  echo $files | xargs $EDITOR
}
