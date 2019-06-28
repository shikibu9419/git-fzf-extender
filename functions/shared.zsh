__git_check_available() {
  git rev-parse > /dev/null 2>&1
}
