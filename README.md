# Arch Dotfiles
My personal dotfiles and setup scripts for Arch Linux

## Installation
Clone the repo:

``` shell
git clone https://github.com/taylorskalyo/arch_dotfiles.git ~/.dotfiles
```

Modify the install script as desired. For example, to install bash instead of zsh, comment out the `setup_zsh` line in `main()` and uncomment `setup_bash`.

``` shell
main() {
  ...
  #setup_zsh
  setup_bash
  ...
}
```

Then run it:

``` shell
chmod +x install.sh
./install.sh -a
```

Run `./install.sh -h` to see usage and additional options.
