# Source shared shell resources
for file in ".aliases" ".functions"; do
  [[ -r "${HOME}/${file}" ]] && source "${HOME}/${file}"
done
unset file

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
PROMPT="\
%{$fg_bold[green]%}%n \
%{$fg_bold[blue]%}%~ \
%{$fg_bold[green]%}%# \
%{$reset_color%}"
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
