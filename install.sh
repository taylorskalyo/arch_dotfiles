#!/bin/bash

# This script can be used to quickly set up various programs and utilities.
# Customize to your liking by commenting or uncommenting steps in main() This 
# script installs packages and moves files around. Use at your own risk!

# TODO:
# - better dependency checks
# - color schemes that apply to multiple utilities
#   - tool that updates multilpe configs?
#   - source a single color scheme in multiple configs?
# - color output to highlight important messages

XDG_CONFIG_HOME="${XDG_CONFIG_HOME-${HOME%/}/.config}"

install_all=false
dot_dir="${HOME%/}/.dotfiles"
backup_dir="${HOME%/}/.backup_dotfiles"
conflict_mode="backup"

install_config() {
  local config_path="$1"
  local config_parent="$(dirname "${config_path}")"
  local rel_path=${config_path#$HOME/}
  local backup_path="${backup_dir%/}/${rel_path}"
  local backup_parent="$(dirname "${backup_path}")"
  local dot_path="${dot_dir%/}/${rel_path}"

  if [[ ! -e "${dot_path}" ]]; then
    echo "WARNING: Config path (${config_path}) doesn't exist in dot directory"
    return 1
  fi

  if [[ "${conflict_mode}" == "backup" ]]; then
    # Back up old config
    if [[ -e "${config_path}" ]]; then
      echo "Moving old config (${config_path}) to (${backup_path})"
      mkdir -p "${backup_parent}"
      mv "${config_path}" "${backup_path}"
    fi
  elif [[ "$conflict_mode" == "overwrite" ]]; then
    # Remove old config
    if [[ -e "${config_path}" ]]; then
      echo "Removing old config (${config_path}) to (${backup_path})"
      rm -rf "${config_path}"
    fi
  fi

  if [[ "${conflict_mode}" != "skip" ]]; then
    # Install new config
    echo "Linking ${dot_path} to ${config_path}"
    mkdir -p "${config_parent}"
    ln -s "${dot_path}" "${config_path}"
  fi
}

setup_yaourt() {
  echo "Setting up yaourt"
  if ! hash yaourt 2>/dev/null; then
    local old_dir="${PWD}"
    cd /tmp
    git clone https://aur.archlinux.org/package-query.git
    cd package-query
    makepkg -si --needed
    cd ..
    git clone https://aur.archlinux.org/yaourt.git
    cd yaourt
    makepkg -si --needed
    cd "${old_dir}"
  fi
  install_config "${XDG_CONFIG_HOME%/}/yaourt/yaourtrc"
}

setup_zsh() {
  echo "Setting up zsh"
  sudo pacman -S --needed zsh
  install_config "${HOME%/}/.zshrc"
  if [[ "${SHELL}" != $(which zsh) ]]; then
    echo "WARNING: Changing default shell from ${SHELL} to $(which zsh)"
    chsh -s $(which zsh)
    echo "Log out and then back in to start using zsh"
  fi
}

setup_bash() {
  echo "Setting up bash"
  sudo pacman -S --needed bash
  install_config "${HOME%/}/.bashrc"
  if [[ "${SHELL}" != $(which bash) ]]; then
    echo "WARNING: Changing default shell from ${SHELL} to $(which bash)"
    chsh -s $(which bash)
    echo "Log out and then back in to start using bash"
  fi
}

setup_env() {
  echo "Setting up shell environment variables"
  install_config "${HOME%/}/.env"
}

setup_aliases() {
  echo "Setting up shell aliases"
  install_config "${HOME%/}/.aliases"
}

setup_functions() {
  echo "Setting up shell functions"
  install_config "${HOME%/}/.functions"
}

setup_the_silver_searcher() {
  echo "Setting up the_silver_searcher (ag)"
  sudo pacman -S --needed the_silver_searcher
}

setup_neovim() {
  echo "Setting up neovim"
  sudo pacman -S --needed neovim
  install_config "${XDG_CONFIG_HOME%/}/nvim/init.vim"
  install_config "${XDG_CONFIG_HOME%/}/nvim/colors/tomorrow-night.vim"

  plug_path="${XDG_CONFIG_HOME%/}/nvim/autoload/plug.vim"
  curl -fLo "${plug_path}" --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  # There seems to be a bug in neovim that prevents calling PlugInstall from 
  # the command line. For now, just call it manually from within neovim.
  # https://github.com/junegunn/vim-plug/issues/104
  # nvim +PlugInstall +qa
  echo "Run :PlugInstall within neovim to install missing plugins"
}

setup_tmux() {
  echo "Setting up tmux"
  sudo pacman -S --needed tmux xsel
  install_config "${HOME%/}/.tmux.conf"
}

init() {
  if [[ ! -e "${dot_dir}" ]]; then
    echo "Dot directory (${dot_dir}) doesn't exist. Please specify a different directory using the -d flag."
    exit 1
  fi
}

show_help() {
  echo "Usage:
  $(basename "$0") [options][module ...]   Install the specified modules

  Arguments:
  -h, ?              Print this help message and exit
  -d                 Directory containing source config files
  -m                 Defines the method to use when conflicts are encountered:
    - backup (default): backup old config files and install new ones
    - overwrite: overwrite old config files with new ones
    - skip: keep old config files
  -b                 Directory to store config file backups
  -a                 Install all available modules"
}

main() {
  OPTIND=1
  while getopts "h?m:d:b:a" opt; do
    case "${opt}" in
      h)
        show_help
        exit 0
        ;;
      \?)
        echo "Invalid option -${OPTARG}"
        show_help
        exit 0
        ;;
      m)  conflict_mode=$OPTARG
        ;;
      d)  dot_dir=$OPTARG
        ;;
      b)  backup_dir=$OPTARG
        ;;
      a)  install_all=true
        ;;
    esac
  done

  shift $((OPTIND-1))

  [[ "$1" == "--" ]] && shift

  init
  if [[ $install_all == true ]]; then
    # Install all modules
    setup_yaourt
    setup_zsh
    #setup_bash
    setup_env
    setup_aliases
    setup_functions
    setup_the_silver_searcher
    setup_neovim
    setup_tmux
  elif [[ "$#" -le 0 ]]; then
    echo "You must specify the -a flag or a module to install"
    show_help
    exit 1
  else
    while [[ -n "$1" && $(declare -Ff "setup_$1") ]]; do
      # Install the specified module
      eval "setup_$1"
      shift
    done
  fi
}

main "$@"
