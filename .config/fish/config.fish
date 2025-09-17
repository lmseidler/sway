if status is-interactive
    set -Ux EDITOR /usr/bin/nvim
    set -Ux VISUAL /usr/bin/nvim
    set -Ux S_EDITOR /usr/bin/nvim
    set -Ux PATH $PATH $HOME/.local/bin
    set -Ux OPENROUTER_API_KEY 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

    alias ls='ls --color=auto'
    alias grep='grep --color=auto'
    alias lsr='ls -alrth'
    alias ni='nvim'
    alias ..='cd ..'
    alias ...='cd ../../'
    alias duh='du -hs ./{.,}* | sort -h'
    alias md='mkdir -p'
end
