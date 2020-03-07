git-extended-init() {
  status='doing'

  while [ $status != 'done' ]; do
    dir=${PWD##*/}

    # form
    printf "Repo name (default: '$dir'): "; read name
    printf 'Description (optional): '; read desc
    printf 'Project page URL (optional): '; read url
    printf 'Will you make this private? (y/n): '; read -q && pri='-p'
    echo

    [ -z $name ] && name=$dir

    # confirmation
  echo "$BOLD---"
  echo "- Repository: $name"
  echo "- Description: $desc"
  echo "- Project page URL: $url"
  [ -n $pri ] && echo '- Make private'
  echo "$DEFAULT"

    printf 'OK? (y/n): '; read -q && status='done'
    echo
  done

  git init &&
    hub create "$name" ${desc:+-d "$desc"} ${url:+-h "$url"} ${pri:+"$pri"} &&
    __git_extended::init::create_readme
}

__git_extended::create_readme() {
  if [ -f 'README.md' ]; then
    echo "# ${PWD##*/}" >> README.md &&
      echo 'README.md is not found: created.'
  fi
}
