repo_dir=${$(realpath "$0")%/*}

for f in $repo_dir/functions/*.zsh; do
  source $f
done

export PATH=$repo_dir/bin:$PATH
