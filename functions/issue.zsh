git-extended-issue() {
  [[ $1 = create ]] \
    && __git_extended::create_issue \
    || __git_extended::list_issue
}

__git_extended::list_issue() {
  __git_extended::init

  open_issues="$(unbuffer hub issue -s open | sed 's/ *#/#/')"
  closed_issues="$(unbuffer hub issue -s closed | sed 's/ *#/#/')"
  opts="${YELLOW}+   CREATE ISSUE\n${MAGENTA}<-> SWITCH STATUS${DEFAULT}"

  stts=open
  while true ; do
    [ $stts = open ] && issues=$open_issues || issues=$closed_issues

    selected=$(echo -e "$issues\n$opts" | sed 's/^[ ]*$//g' | fzf-tmux -d --ansi --no-sort --reverse --prompt="Select issue ($stts)> ")

    case "$selected" in
      '<->'*)
        [ $stts = open ] && stts=closed || stts=open
        continue
        ;;
      '+'*)
        __git_extended::create_issue
        ;;
      "")
        ;;
      *)
        hub browse -- issues/$(echo $selected | cut -d' ' -f1 | cut -b 2-)
    esac

    return
  done
}

__git_extended::create_issue() {
  __git_extended::init
  echo "${BOLD}--- CREATE MODE ---${DEFAULT}"

  printf 'Message: '; read msg

  printf 'Labels: '
  selected=$(unbuffer hub issue labels |
             fzf -m --ansi --no-sort --reverse --tiebreak=index --prompt='SELECT LABEL> ' |
             tr '\n' ',' | sed -e 's/ *//g' -e 's/,$//')
  echo $selected

  echo
  echo 'Creating issue...'
  label_opt=${selected:+-l $selected}

  hub issue create ${msg:+-m $msg} $=label_opt \
    && echo 'Done!' \
    || echo 'Failed...'
}
