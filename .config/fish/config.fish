if status is-interactive
    set -Ux EDITOR /usr/bin/nvim
    set -Ux VISUAL /usr/bin/nvim
    set -Ux S_EDITOR /usr/bin/nvim
    set -Ux PATH $PATH $HOME/.local/bin

    alias ls='ls --color=auto'
    alias grep='grep --color=auto'
    alias lsr='ls -alrth'
    alias ni='nvim'
    alias ..='cd ..'
    alias ...='cd ../../'
    alias duh='du -hs ./{.,}* | sort -h'
    alias md='mkdir -p'
    alias bwl='set -gx BW_SESSION (bw unlock --raw)'
end
