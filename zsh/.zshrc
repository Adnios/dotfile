export ZSH="/home/herewj/.oh-my-zsh"
export I3BIN="/home/herewj/.config/i3/bin"
VISUAL=nvim
export VISUAL
EDITOR=nvim
export EDITOR

ZSH_THEME="powerlevel10k/powerlevel10k"

plugins=(
  git
  zsh-autosuggestions
  vi-mode
  zsh-syntax-highlighting
  colored-man-pages
  autojump
)
source $ZSH/oh-my-zsh.sh

KEYTIMEOUT=1
bindkey ";" autosuggest-accept
# Editor
export EDITOR="nvim"
export GIT_EDITOR="nvim"
export REACT_EDITOR="nvim"
# export TERM=xterm-256color

alias r=ranger
alias t="conda activate base && tmux"
alias ta="t a -t"
alias tls="t ls"
alias tn="t new -t"
alias reload="source ~/.zshrc"
alias ls="lsd"
alias ll="ls -l"
alias la="ls -la"
alias lt="ls --tree"
alias nvim="fq && nvim"
# https://aduros.com/blog/hacking-i3-window-swallowing/
# alias sxiv="$I3BIN/i3-tabbed sxiv"
alias ssh="export TERM=xterm-256color && kitty +kitten ssh"

fq(){
export HTTP_PROXY='http://127.0.0.1:12333'
export HTTPS_PROXY='http://127.0.0.1:12333'
export ALL_PROXY='socks5://127.0.0.1:1080'
}

# open file
fo() {
  #IFS=′\n′out=("(fzf-tmux --query="$1" --exit-0 --expect=ctrl-o,ctrl-e)")
  IFS=$'\n' out=($(fzf --query="$1" --multi))
  key=$(head -1 <<< "$out")
  file=$(head -2 <<< "$out" | tail -1)
  if [ -n "$file" ]; then
    [ "$key" = ctrl-o ] && open "$file" || ${EDITOR:-nvim} "$file"
  fi
}

# cd directory and open file can pass word
fcd() {
  local dir
  dir=$(fd --hidden --type d "$1" . $HOME | fzf --preview 'tree -C {}' +m) && cd "$dir"
}

# cd directory and open file can pass word
co() {
  local dir
  dir=$(fd --hidden --type d "$1" . $HOME | fzf --preview 'tree -C {}' +m) && cd "$dir" && fo
}

# find-in-file - usage: fif <searchTerm>
fif() {
  if [ ! "$#" -gt 0 ]; then echo "Need a string to search for!"; return 1; fi
  rg --files-with-matches --no-messages "$1" | fzf --preview "highlight -O ansi -l {} 2> /dev/null | rg --colors 'match:bg:yellow' --ignore-case --pretty --context 10 '$1' || rg --ignore-case --pretty --context 10 '$1' {}"
}

lg()
{
    export LAZYGIT_NEW_DIR_FILE=~/.lazygit/newdir

    lazygit "$@"

    if [ -f $LAZYGIT_NEW_DIR_FILE ]; then
            cd "$(cat $LAZYGIT_NEW_DIR_FILE)"
            rm -f $LAZYGIT_NEW_DIR_FILE > /dev/null
    fi
}

# vim way
# \e[0 block without blink
# \e[1 block with blink
# \e[5 beam with blink
# \e[6 beam without blink
function zle-keymap-select {
	if [[ ${KEYMAP} == vicmd ]] || [[ $1 = 'block' ]]; then
		echo -ne '\e[0 q'
	elif [[ ${KEYMAP} == main ]] || [[ ${KEYMAP} == viins ]] || [[ ${KEYMAP} = '' ]] || [[ $1 = 'beam' ]]; then
		echo -ne '\e[6 q'
  fi
}
zle -N zle-keymap-select

# Use beam shape cursor on startup.
# echo -ne '\e[6 q'

# Use beam shape cursor for each new prompt.
preexec() {
	echo -ne '\e[6 q'
}

_fix_cursor() {
	echo -ne '\e[6 q'
}
precmd_functions+=(_fix_cursor)

# Use vim keys in tab complete menu:
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history
# bindkey -v '^?' backward-delete-char


# ranger
set RANGER_LOAD_DEFAULT_RC = FALSE

export PATH="$HOME/.local/bin:$PATH"
export PATH=/home/herewj/bin:$PATH

# export PATH=$PATH:/opt/cuda/bin
# export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/opt/cuda/lib64
# export CUDA_HOME=$CUDA_HOME:/opt/cuda

export CPATH=/usr/local/cuda/targets/x86_64-linux/include:$CPATH
export LD_LIBRARY_PATH=/usr/local/cuda/targets/x86_64-linux/lib:$LD_LIBRARY_PATH
export PATH=/usr/local/cuda/bin:$PATH

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k-evilball.zsh ]] || source ~/.p10k-evilball.zsh

# Fzf
export FZF_COMPLETION_TRIGGER='**'
export FZF_DEFAULT_COMMAND='rg --files --hidden'
export FZF_DEFAULT_OPTS='--height 90% --layout reverse --border --color "border:#b877db" --preview="bat --color=always {}"'
export BAT_THEME="TwoDark"
source /usr/share/fzf/key-bindings.zsh
source /usr/share/fzf/completion.zsh


# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/herewj/miniconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/herewj/miniconda3/etc/profile.d/conda.sh" ]; then
        . "/home/herewj/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="/home/herewj/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

