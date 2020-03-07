git-extended-commit() {
  __git_extended::init || return 1

  GIT_ROOT=$(git rev-parse --show-cdup)
  TEMPLATES_ROOT=${GIT_ROOT}${GITHUB_TEMPLATES_PATH}
  PREFIXES_FILE=$TEMPLATES_ROOT/$GITHUB_COMMIT_PREFIXES

  echo "${BOLD}--- NEW COMMIT ---${DEFAULT}"

  prompt_msg='SELECT PREFIX> '
  if [ -d $TEMPLATES_ROOT ] && [ -f $PREFIXES_FILE ]; then
    printf 'Prefix: '
    local prompt_msg='SELECT PREFIX> '
    prefix=$(cat $PREFIXES_FILE | sed '1d' |
             $=FZF_TMUX --prompt=$prompt_msg |
             cut -d' ' -f1)

    [[ -z $prefix ]] && { echo 'No prefix selected.'; return 1 }

    echo $prefix
  fi

  printf 'Message: '; read msg

  echo
  echo 'Committing...'
  git commit -m "$prefix $msg" \
    && echo 'Done!' \
    || echo 'Failed...'
}
