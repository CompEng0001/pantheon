# [[ SYSTEM ]]

alias -- deploy='sudo nixos-rebuild --flake /home/dev/Git/pantheon/.#scirocco switch --impure'
alias -- refresh='source ~/.zshrc'
alias -- wifi='~/.config/scripts/bash/wifi.sh'

# [[ GIT ]]
alias -- gcleam='git gc --aggressive --prune=now'
alias -- gst='git status'
alias -- ga='git add'
alias -- gaa='git add .'
alias -- gcma='git commit -am'
alias -- gca='git commit --amend'
alias -- gcm='git commit -m'
alias -- gd='git diff'
alias -- glg='git log --graph --oneline --decorate --all'
alias -- gps='git push'
alias -- gpl='git pull'
alias -- gfa='git fetch -va'
alias -- gd='git diff'
alias -- gtp='~/Git/contributor/git_utils/git_tagging/target/release/./git_tagging'
alias -- gw='~/Git/contributor/git_utils/git_workflows/target/release/./git_workflows'
alias -- gitStats='~/Git/contributor/git_utils/git_stats/target/release/./git_stats'
alias -- gitCheck='~/Git/contributor/git_utils/git_better-branch/target/release/./git_better-branch'

# [[ GENERICS ]]
alias -- passcode='~/Git/.secrets/.OTP/target/release/./OTP'
alias -- pwdGen='~/Git/contributor/pwdGenUtil/target/release/./pwdGenUtil'
alias -- mdbook-pwd='mdbook serve . -p 8000 -n 127.0.0.1'
alias -- marp-watch='marp --watch $1 --html --theme themes/uog-theme.css'
alias -- marp-pdf='marp -I $1 -o $1 --html --pdf --allow-local-files --browser firefox --theme themes/uog-theme.css'
