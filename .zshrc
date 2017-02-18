# Source shared shell resources
if [[ -d "${XDG_CONFIG_HOME:=$HOME/.config}/shell" ]]; then
  for file in "${XDG_CONFIG_HOME}"/shell/*; do
    [[ -r "${file}" ]] && source "${file}"
  done
fi

# History
HISTFILE="${HOME}/.histfile"
HISTSIZE=1000
SAVEHIST="${HISTSIZE}"
setopt appendhistory
setopt histignorespace
setopt histignoredups

# Fix minor spelling mistakes
setopt correct

# Completion
zstyle :compinstall filename "${HOME}/.zshrc"
autoload -Uz compinit
compinit

# Search history
bindkey "^R" history-incremental-search-backward

# Colors
autoload -U colors
colors

# Left prompt
PROMPT="%B\
%{$fg[green]%}%n \
%{$fg[blue]%}%~ \
%{$fg[green]%}%# \
%{$reset_color%}%b"
autoload -U promptinit
promptinit

# Vi-like bindings
bindkey -v

# Change cursor based on mode
zle-keymap-select() {
  case "${KEYMAP}" in
    vicmd)      print -rn -- "${terminfo[cvvis]}";; # "very visible" cursor
    viins|main) print -rn -- "${terminfo[cnorm]}";; # normal cursor
  esac
}
zle -N zle-keymap-select

# Reduce mode switch lag
KEYTIMEOUT=3
