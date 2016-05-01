# -----------------
# External Resources
# ------------------------------------------------------------------------------
RESOURCES=("env" "aliases" "functions" "private")
for FILE in "${RESOURCES[@]}"; do
  [[ -f "${HOME%/}/.${FILE}" ]] && source "${HOME%/}/.${FILE}"
done

# -----------------
# History
# ------------------------------------------------------------------------------
export HISTSIZE=10000
export HISTFILESIZE=${HISTSIZE}
export HISTCONTROL=ignoreboth # do not add duplicates or commands starting with a space
shopt -s histappend # append to history instead of overwriting

# -----------------
# Tab Completion
# ------------------------------------------------------------------------------
[[ -s /etc/bash_completion ]] && source /etc/bash_completion

complete -cf sudo

# -----------------
# Options
# ------------------------------------------------------------------------------
shopt -s cdspell # fix minor spelling errors
shopt -s checkwinsize # update window contents after resize
shopt -s cmdhist # consolidate multiline commands in history
shopt -s dotglob # include filenames starting with '.' in globs
shopt -s expand_aliases # expand aliases
shopt -s hostcomplete # attempt to autocomplete hostnames
shopt -s nocaseglob # case insensitive globbing

# -----------------
# Prompt
# ------------------------------------------------------------------------------
PS1="\
\[\e[1;92m\]\u \
\[\e[1;94m\]\w \
\[\e[1;92m\]\$ \
\[\e[m\]"
