git-extended-checkout() {
  __git_extended::init || { __git_extended::error; return 1 }

  branch=$(git branch --all | grep -v HEAD |
           $=FZF_TMUX |
           sed 's/.* //' | sed 's#remotes/[^/]*/##')
  [[ -n $branch ]] && git checkout $branch
  zle reset-prompt
}

zle -N git-extended-checkout
