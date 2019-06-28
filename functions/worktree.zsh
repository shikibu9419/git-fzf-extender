git-extended-worktree() {
  work_dir=$(git worktree list | fzf --ansi | cut -d' ' -f1)
  [[ -n $work_dir ]] && cd $work_dir
}
