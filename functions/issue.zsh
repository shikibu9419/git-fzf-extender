readonly GREEN='\033[32m'
readonly YELLOW='\033[33m'
readonly BLUE='\033[34m'
readonly MAGENTA='\033[35m'
readonly BOLD='\033[1m'
readonly DEFAULT='\033[m'

git-extended-issue() {
  [[ $1 = create ]] \
    && __git_extended::create_issue \
    || __git_extended::list_issue
}

__git_extended::list_issue() {
  stts=${1:-open}

  opts="$(unbuffer hub issue -s $stts | sed 's/ *#/#/')"
  opts="$opts\n${YELLOW}+   CREATE ISSUE\n${MAGENTA}<-> SWITCH STATUS${DEFAULT}"

  selected=$(echo -e $opts | fzf-tmux -d --ansi --no-sort --reverse --prompt="Select issue ($stts)> ")

  case "$selected" in
    '+'*)
      __git_extended::create_issue
      ;;
    '<->'*)
      new_status='open'
      [ $stts = 'open' ] && new_status='closed'
      __git_extended::list_issue $new_status
      ;;
    "")
      ;;
    *)
      hub browse -- issues/$(echo $selected | cut -d' ' -f1 | cut -b 2-)
  esac
}

__git_extended::create_issue() {
  echo "${BOLD}--- CREATE MODE ---${DEFAULT}"

  printf 'Message: '; read msg

  printf 'Labels: '
  selected=$(unbuffer hub issue labels |
             fzf -m --ansi --no-sort --reverse --tiebreak=index --prompt='SELECT LABEL> ' |
             tr '\n' ',' | sed -e 's/ *//g' -e 's/,$//')
  echo $selected

  echo
  echo 'Creating issue...'
  label_opt=${selected:+-l $selected}

  hub issue create ${msg:+-m $msg} $=label_opt \
    && echo 'Done!' \
    || echo 'Failed...'
}

git-extended-issue
