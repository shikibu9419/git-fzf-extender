git-extended-init() {
  printf 'Repo name: '; read name
  printf 'Description: '; read desc
  printf 'Project page URL: '; read url
  printf 'Will you make this private?: '; read -q && pri='-p'

  echo
  git init &&
    hub create "$name" ${desc:+-d "$desc"} ${url:+-h "$url"} ${pri:+"$pri"}

  [ -f 'README.md' ] ||
    echo "# ${PWD##*/}" >> README.md &&
    echo 'Create README.'
}
