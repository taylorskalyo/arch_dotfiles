# Source shared shell resources
for file in ".aliases" ".functions"; do
  [[ -r "${HOME}/${file}" ]] && source "${HOME}/${file}"
done
unset file

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
\[\e[92m\]\u \
\[\e[94m\]\w \
\[\e[92m\]\$ \
\[\e[m\]"
