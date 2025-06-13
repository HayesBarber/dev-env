
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

copy() { tee /dev/tty | pbcopy; }
copy_branch() { current_branch | copy; }
cpath() { pwd | copy; }
copy_ip() { ip | copy; }

source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
