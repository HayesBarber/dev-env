
alias gcm="git checkout main || git checkout master"
alias gl="git pull"
alias gr="git restore ."
alias gs="git status"
alias gd="git diff"
alias current_branch="git rev-parse --abbrev-ref HEAD"

format_current_branch() {
    current_branch 2> /dev/null | sed "s/\(.*\)/[\1] /"
}

set_prompt() {
    PROMPT="%B%F{green}%1d $(format_current_branch)➤➤➤ %b%f"
}

precmd_functions+=(set_prompt)

# auto commit
acm() {
    git add .
    local message="$*"
    if [[ -z "$message" ]]; then
        message="auto commit"
    fi
    git commit -m "$message"
    git push
}

pr() {}

compare() {
  local remote=$(git remote get-url origin 2>/dev/null)

  if [[ -z $remote ]]; then
    echo "Not a git repository or no origin remote found"
    return 1
  fi

  local base_domain repo_path

  if [[ "$remote" =~ ^git@([^:]+):(.+)\.git$ ]]; then
    base_domain="${match[1]}"
    repo_path="${match[2]}"
  elif [[ "$remote" =~ ^https://([^/]+)/(.+)\.git$ ]]; then
    base_domain="${match[1]}"
    repo_path="${match[2]}"
  else
    echo "Unsupported remote format: $remote"
    return 1
  fi

  local current_branch=$(current_branch)

  local main_branch
  if git show-ref --quiet refs/remotes/origin/main; then
    main_branch="main"
  elif git show-ref --quiet refs/remotes/origin/master; then
    main_branch="master"
  else
    echo "Neither 'main' nor 'master' branch found on origin"
    return 1
  fi

  if [[ "$current_branch" == "$main_branch" ]]; then
    echo "You are already on the $main_branch branch"
    return 1
  fi

  local url="https://${base_domain}/${repo_path}/compare/${main_branch}...${current_branch}"
  echo "Opening diff: $url"
  open "$url"
}

copy() { tee /dev/tty | pbcopy; }
copy_branch() { current_branch | copy; }
cpath() { pwd | copy; }
copy_ip() { ip | copy; }

source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
