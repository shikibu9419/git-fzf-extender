repo_dir=${$(realpath "$0")%/*}

for f in $repo_dir/functions/*.zsh; do
  source $f
done

export PATH=$repo_dir/bin:$PATH
export GITHUB_TEMPLATES_PATH=.github
export GITHUB_COMMIT_PREFIXES=$GITHUB_TEMPLATES_PATH/COMMIT_PREFIXES
