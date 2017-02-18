# Source shared shell resources
if [[ -d "${XDG_CONFIG_HOME:=$HOME/.config}/shell" ]]; then
  for file in "${XDG_CONFIG_HOME}"/shell/*; do
    [[ -r "${file}" ]] && source "${file}"
  done
fi

# History
HISTSIZE=1000
HISTFILESIZE="${HISTSIZE}"
HISTCONTROL=ignoreboth # ignore duplicates and space-prefixed commands in history
HISTTIMEFORMAT="%X "   # add timestamps to history
shopt -s histappend    # append to history instead of overwriting
shopt -s cmdhist       # consolidate multiline commands in history

# Fix minor spelling mistakes
shopt -s cdspell

# Completion
[[ -s /etc/bash_completion ]] && source /etc/bash_completion
complete -cf sudo
shopt -s hostcomplete # attempt to autocomplete hostnames

# Update window contents after resize
shopt -s checkwinsize

# Prompt
PS1="\[\e[1m\]\
\[\e[32m\]\u \
\[\e[34m\]\w \
\[\e[32m\]\$ \
\[\e[m\]"
