# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
setopt extendedglob
unsetopt autocd
bindkey -v
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/polt/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

# Prompt configuration
autoload -Uz vcs_info
precmd() { vcs_info }
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:git:*' check-for-changes false # FIXME: this doesn't seem to work, so false for now, maybe take stuff from omz git lib instead
zstyle ':vcs_info:git:*' unstagedstr ' *'
zstyle ':vcs_info:git:*' stagedstr ' +'
zstyle ':vcs_info:git:*' formats ' [%s::%b%m%u%c]'
zstyle ':vcs_info:git:*' actionformats ' [%s::%b%m%u%c|%a]'

setopt prompt_subst
PS1='%F{red}%B%/%b%f%F{green}${vcs_info_msg_0_}%f %F{white}[%n@%m]%f [%F{white}%T%f]
%_> '

# Alias
alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias lsr='ls -alrth'
alias ni='nvim'
alias ..="cd .."
alias ...="cd ../../"

source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.plugin.zsh
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.plugin.zsh
