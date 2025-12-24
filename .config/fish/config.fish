if status is-interactive
    # Commands to run in interactive sessions can go here
end
set -gx EDITOR hx
set -x GOPATH $HOME/.local/share/go
export PATH=/usr/local/bin:$HOME/.local/share/go/bin:$HOME/.local/bin:$PATH

eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

bind \cz 'fb 2>/dev/null; commandline -f repaint'

if type -q eza
    alias ll "eza -l -g --icons --git"
end

if type -q eza
    alias ls "eza --icons --git"
end

if type -q lazygit
    alias lg lazygit
end

starship init fish | source