export PATH=$HOME/bin:$HOME/.local/bin:$HOME/.local/share/go/bin:/usr/local/bin:$PATH

export EDITOR=hx
export VISUAL=hx
export GOPATH="$HOME/.local/share/go"
export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="fishy"


zstyle ':omz:update' frequency 1

ENABLE_CORRECTION="true"

COMPLETION_WAITING_DOTS="true"

plugins=(
  git
  fzf
  zsh-autosuggestions
  zsh-syntax-highlighting
  zsh-history-substring-search
)

fpath+=${ZSH_CUSTOM:-${ZSH:-~/.oh-my-zsh}/custom}/plugins/zsh-completions/src
fpath+=${ZSH_CUSTOM:-${ZSH:-~/.oh-my-zsh}/custom}/completions
autoload -U compinit && compinit

source $ZSH/oh-my-zsh.sh

export FZF_DEFAULT_OPTS="
--height 40%
--layout=reverse
--border
--info=inline
"
function Resume {
  fg
  zle push-input
  BUFFER=""
  zle accept-line
}
zle -N Resume
bindkey "^Z" Resume

alias lg="lazygit"
alias vim="nvim"

