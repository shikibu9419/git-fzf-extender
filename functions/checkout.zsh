git-extended-checkout() {
  branch=$(git branch --all | grep -v HEAD |
           fzf-tmux --ansi -d |
           sed 's/.* //' | sed 's#remotes/[^/]*/##')
  [[ -n $branch ]] && git checkout $branch
  zle reset-prompt
}

zle -N git-extended-checkout
