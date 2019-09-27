git-extended-init() {
  stts='doing'

  while [ $stts != 'done' ]; do
    dir=${PWD##*/}

    # form
    printf "Repo name (default: '$dir'): "; read name
    printf 'Description: '; read desc
    printf 'Project page URL: '; read url
    printf 'Will you make this private?: '; read -q && pri='-p'
    echo

    [ -z $name ] && name=$dir

    # confirmation
  echo -e "
$BOLD---
Repository: $name
Description: $desc
Project page URL: $url"

    [ -n $pri ] && echo 'Make private'

    echo "$DEFAULT"

    printf 'OK?: '; read -q && stts='done'
    echo
  done

  git init && hub create "$name" ${desc:+-d "$desc"} ${url:+-h "$url"} ${pri:+"$pri"}

  [ -f 'README.md' ] || { echo "# ${PWD##*/}" >> README.md && echo 'README is not found. Created.' }
}
