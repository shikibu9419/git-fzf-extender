git-extended-commit() {
  __git_extended::init || { __git_extended::error; return 1 }

  GIT_ROOT=$(git rev-parse --show-cdup)
  TEMPLATES_ROOT=${GIT_ROOT}${GITHUB_TEMPLATES_PATH}

  echo "${BOLD}--- NEW COMMIT ---${DEFAULT}"

  prompt_msg='SELECT PREFIX> '
  if [ -d $TEMPLATES_ROOT ] && [ -f $GITHUB_COMMIT_PREFIXES ]; then
    printf 'Prefix: '
    local prompt_msg='SELECT PREFIX> '
    prefix=$(cat $GITHUB_COMMIT_PREFIXES | sed '1d' |
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
