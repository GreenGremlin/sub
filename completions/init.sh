
case "$0" in
bash | zsh)
  . "$_SUB_ROOT/completions/sub.$0"
  ;;
-bash )
  . "$_SUB_ROOT/completions/sub.bash"
  ;;
esac
