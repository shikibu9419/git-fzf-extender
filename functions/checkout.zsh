git-extended-checkout() {
  branch=$(git branch --all | grep -v HEAD | fzf-tmux --ansi -d)
  [ -n $branch ] && git checkout $(echo $branch | sed 's/.* //' | sed 's#remotes/[^/]*/##')
  zle reset-prompt
}

zle -N git-extended-checkout
