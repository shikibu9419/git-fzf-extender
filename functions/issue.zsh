git-extended-issue() {
  __git_extended::init || { __git_extended::error; return 1 }

  [[ $1 = create ]] \
    && __git_extended::create_issue \
    || __git_extended::list_issue
}

__git_extended::list_issue() {
  open_issues="$(unbuffer hub issue -s open | sed 's/ *#/#/')"
  closed_issues="$(unbuffer hub issue -s closed | sed 's/ *#/#/')"
  opts="${YELLOW}+   CREATE ISSUE\n${MAGENTA}<-> SWITCH STATUS${DEFAULT}"
  stts=open

  while true ; do
    [ $stts = open ] && issues=$open_issues || issues=$closed_issues

    prompt_msg="Select issue ($stts)> "
    selected=$(echo -e "$issues\n$opts" | sed '/^$/d' | $=FZF --prompt=$prompt_msg)

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
  prompt_msg='SELECT LABEL> '

  echo "${BOLD}--- CREATE MODE ---${DEFAULT}"

  printf 'Message: '; read msg

  printf 'Labels: '
  selected=$(unbuffer hub issue labels |
             $=FZF -m --prompt=$prompt_msg |
             tr '\n' ',' | sed -e 's/ *//g' -e 's/,$//')
  echo $selected

  echo
  echo 'Creating issue...'
  label_opt=${selected:+-l $selected}

  hub issue create ${msg:+-m $msg} $=label_opt \
    && echo 'Done!' \
    || echo 'Failed...'
}
