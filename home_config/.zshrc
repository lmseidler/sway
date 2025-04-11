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
zstyle ':vcs_info:git:*' formats ' [%s::%b%u%c]'
zstyle ':vcs_info:git:*' actionformats ' [%s::%b%u%c|%a]'

setopt prompt_subst
PS1='%F{red}%B%/%b%f%F{green}${vcs_info_msg_0_}%f %F{white}[%n@%m]%f [%F{white}%T%f]
%_> '

# Case-insensitive completion
autoload -Uz compinit && compinit
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

# Alias
alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias lsr='ls -alrth'
alias ni='nvim'
alias ..="cd .."
alias ...="cd ../../"
alias duh="du -hs ./{.,}* | sort -h"
alias md='mkdir -p'
export PATH="$PATH:$HOME/bin:$HOME/.local/bin:"

source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.plugin.zsh
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.plugin.zsh

# Lazy loading conda
# Add any commands which depend on conda here
lazy_conda_aliases=('conda')

load_conda() {
  for lazy_conda_alias in $lazy_conda_aliases
  do
    unalias $lazy_conda_alias
  done

  __conda_prefix="/opt/miniforge" # Set your conda Location

  # >>> conda initialize >>>
  __conda_setup="$("$__conda_prefix/bin/conda" 'shell.zsh' 'hook' 2> /dev/null)"
  if [ $? -eq 0 ]; then
      eval "$__conda_setup"
  else
      if [ -f "$__conda_prefix/etc/profile.d/conda.sh" ]; then
          . "$__conda_prefix/etc/profile.d/conda.sh"
      else
          export PATH="$__conda_prefix/bin:$PATH"
      fi
  fi
  unset __conda_setup
  # <<< conda initialize <<<

  unset __conda_prefix
  unfunction load_conda
}

for lazy_conda_alias in $lazy_conda_aliases
do
  alias $lazy_conda_alias="load_conda && $lazy_conda_alias"
done
