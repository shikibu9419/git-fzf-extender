dir=${$(realpath "$0")%/*}

for f in $dir/functions/*.zsh; do
  source $f
done
