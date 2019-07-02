git-extended-grep() {
  [[ -z $1 ]] && return
  local HIGHLIGHT='highlight --force -O ansi -n'

  files=$(git grep --max-depth 1 -n $1 | cut -d: -f1,2 | sed 's/:/ - /' |
          fzf -m --ansi --preview="set {}; $HIGHLIGHT {1} | grep --color=always -e $ -e $1" |
          cut -d' ' -f1 | sort | uniq | tr '\n' ' ')

  [[ -z $files ]] && return
  echo $files | xargs $EDITOR
}
