git-extended-worktree() {
  __git_extended::init || { __git_extended::error; return 1 }

  work_dir=$(git worktree list | $=FZF_TMUX | cut -d' ' -f1)
  [[ -n $work_dir ]] && cd $work_dir
}
