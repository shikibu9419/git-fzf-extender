git-extended-pull-request() {
  __git_extended::init || { __git_extended::error; return 1 }

  [[ $1 = create ]] \
    && __git_extended::create_pr \
    || __git_extended::list_pr
}

__git_extended::list_pr() {
  open_prs="$(unbuffer hub pr list -s open | sed 's/ *#/#/')"
  closed_prs="$(unbuffer hub pr list -s closed | sed 's/ *#/#/')"
  opts="${YELLOW}+   CREATE PULL REQUEST\n${MAGENTA}<-> SWITCH STATUS${DEFAULT}"
  stts=open

  while true ; do
    [ $stts = open ] && prs=$open_prs || prs=$closed_prs

    prompt_msg="SELECT PR ($stts)> "
    selected=$(echo -e "$prs\n$opts" | sed '/^$/d' |
               $=FZF --prompt=$prompt_msg
                     --bind "ctrl-l:execute(echo {} | cut -d' ' -f1 | cut -b 2- | hub pr checkout)")

    case "$selected" in
      '<->'*)
        [ $stts = open ] && stts=closed || stts=open
        continue
        ;;
      '+'*)
        __git_extended::create_pr
        ;;
      "")
        ;;
      *)
        hub pr show $(echo $selected | cut -d' ' -f1 | cut -b 2-)
    esac

    return
  done
}

__git_extended::create_pr() {
  GIT_ROOT=$(git rev-parse --show-cdup)
  TEMPLATES_ROOT=${GIT_ROOT}${GITHUB_TEMPLATES_PATH}

  echo "${BOLD}--- CREATE MODE ---${DEFAULT}"

  if [ -d $TEMPLATES_ROOT ] && [ -f $TEMPLATES_ROOT/PULL_REQUEST* ]; then
    printf 'Template: '
    local prompt_msg='SELECT TEMPLATE> '
    local prev_cmd="less -R $TEMPLATES_ROOT/{}"
    template=$(ls $TEMPLATES_ROOT/PULL_REQUEST* | xargs -I % sh -c 'basename %' |
              $=FZF --prompt=$prompt_msg --preview=$prev_cmd)
    echo $template
  fi
  if [[ -z $template ]]; then
    printf 'Message: '; read msg
  fi

  local prompt_msg='SELECT LABEL> '
  printf 'Labels: '
  selected=$(unbuffer hub issue labels |
             $=FZF -m --prompt=$prompt_msg |
             tr '\n' ',' | sed -e 's/ *//g' -e 's/,$//')
  echo $selected

  echo
  echo 'Creating PR...'
  label_opt=${selected:+-l $selected}
  template_opt=${template:+-F $TEMPLATES_ROOT/$template --edit}

  hub pull-request ${msg:+-m $msg} $=template_opt $=label_opt \
    && echo 'Done!' \
    || echo 'Failed...'
}
