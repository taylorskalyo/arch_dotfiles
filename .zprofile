# Config directory
export XDG_CONFIG_HOME="${HOME}/.config"

# Default editor
for EDITOR in "nvim" "vim" "vi"; do
  if [[ $(command -v "${EDITOR}") ]]; then
    export EDITOR
    break
  fi
done
SUDO_EDITOR="${EDITOR}"
export SUDO_EDITOR

# Default browser
for BROWSER in "qutebrowser" "firefox"; do
  if [[ $(command -v "${BROWSER}") ]]; then
    export BROWSER
    break
  fi
done

# Path
export PATH="${PATH}:${HOME}/bin"

# SSH-agent
export SSH_AUTH_SOCK="${XDG_RUNTIME_DIR}/ssh-agent.socket"

# Move weechat
export WEECHAT_HOME="${XDG_CONFIG_HOME}/weechat"
