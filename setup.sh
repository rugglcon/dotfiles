#!/bin/bash

# this script should be run to set up the directory structure
# right after cloning the repo, run with 'sudo -u <username> ./setup.sh'

# default BINDIR. can be set with -b
BINDIR="$HOME/bin"
PATHADD=1
# default config dir. can be set with -c
CONFDIR=$HOME

# `readlink` command
READLINK="$(which readlink)"
# get operating system; only useful for Mac or Arch; not reliable for Ubuntu/Fedora/Debian
uname_v="$(uname -v)"

if [[ -f "$HOME/.local/shared/common.sh" ]]; then
	. "$HOME/.local/shared/common.sh"
elif [[ -f "shared/common.sh" ]]; then
	. "shared/common.sh"
else
	printf "%s\n" "common functions not found. exiting." 1>&2
	exit 1
fi


path_check() {
	if [[ ! ":$PATH:" == *":$BINDIR:"* ]]; then
		printf "%s\n" "adding $BINDIR to PATH..."
		printf "export PATH=$PATH:$BINDIR\n" >> ~/.profile
		PATHADD=0
	else
		printf "%s\n" "$BINDIR already exists in PATH"
	fi
}

install_vim_pacs() {
	apt install libncurses5-dev libgnome2-dev libgnomeui-dev libgtk2.0-dev libatk1.0-dev libbonoboui2-dev libcairo2-dev libx11-dev libxpm-dev libxt-dev python-dev ruby-dev liblua5.1-dev lua5.1 libperl-dev
}

install_vim_final() {
	cd $HOME/vim
	./configure --with-features=huge --enable-multibyte --enable-rubyinterp=yes --enable-pythoninterp=yes --with-python-config-dir=/usr/lib/python2.7/config-x86_64-linux-gnu --enable-perlinterp=yes --enable-luainterp=yes --enable-gui=gtk2 --enable-cscope --enable-terminal --prefix=/usr
	make VIMRUNTIMEDIR=/usr/share/vim/vim81
	make install

	make_editor
}

make_editor() {
	update-alternatives --install /usr/bin/editor editor /usr/bin/vim 1
	update-alternatives --set editor /usr/bin/vim
	update-alternatives --install /usr/bin/vi vi /usr/bin/vim 1
	update-alternatives --set vi /usr/bin/vim
}

install_vim() {
	while true; do
		read -p "install vim? [Y/n] " yn
		case $yn in
			[Yy])
				grep -q 'Ubuntu' <<< "$uname_v"
				if [[ $? -eq 0 ]]; then
					install_vim_pacs
					git clone https://github.com/vim/vim.git $HOME/vim
					install_vim_final
					apt install python3-pip
				elif grep -q 'Arch' <<< "$uname_v"; then
					pacman -S vim
				elif [[ -f /etc/system-release ]]; then
					dnf update && dnf upgrade && dnf install vim
				fi
				break
				;;
			[Nn])
				printf "%s\n" "not installing vim"
				break
				;;
			*)
				printf "%s\n" "Please enter [Yy] or [Nn]"
				;;
		esac
	done
}

install_scripts() {
	mkdir -p $BINDIR

	if grep -q "Arch" <<< "$uname_v"; then
		if ! hash yaourt 2>/dev/null; then
			printf "Installing yaourt...\n"
			pacman -S --needed base-devel git wget yajl
			cd $HOME
			git clone https://aur.archlinux.org/package-query.git
			cd package-query/
			makepkg -si
			cd ..
			git clone https://aur.archlinux.org/yaourt.git
			cd yaourt/
			makepkg -si
			cd ../ && rm -rf yaourt/ package-query/
		fi
	fi

	if ! hash wal 2>/dev/null; then
		if grep -q "Arch" <<< "$uname_v"; then
			yaourt -S python-pywal-git
		else
			pip3 install pywal
		fi
	fi

	printf "%s\n" "installing scripts..."
	cp scripts/* $BINDIR

	if [[ $PATHADD -eq 0 ]]; then
		export PATH=$PATH:$BINDIR
		source ~/.profile
	fi
}

install_configs() {
	printf "%s\n" "linking configs..."
	cd $HOME/dotfiles

	ln -fs "$($READLINK -f .vim)" "$CONFDIR/.vim"
	mkdir -p $CONFDIR/.config
	#ln -fs "$($READLINK -f cava)" "$CONFDIR/.config/cava"
	#ln -fs "$($READLINK -f config/i3)" "$CONFDIR/.config/i3"
	#ln -fs "$($READLINK -f config/polybar)" "$CONFDIR/.config/polybar"
	#ln -fs "$($READLINK -f config/lemonbar)" "$CONFDIR/.config/lemonbar"
	# ln -fs "$($READLINK -f .bash_aliases)" "$CONFDIR/.bash_aliases"
	# ln -fs "$($READLINK -f .bashrc)" "$CONFDIR/.bashrc"
	# ln -fs "$($READLINK -f .profile)" "$CONFDIR/.profile"
	ln -fs "$($READLINK -f .tmux.conf)" "$CONFDIR/.tmux.conf"
	#ln -fs "$($READLINK -f .xinitrc)" "$CONFDIR/.xinitrc"
	#ln -fs "$($READLINK -f .Xresources)" "$CONFDIR/.Xresources"
	#cp -f "$($READLINK -f .muttrc)" "$CONFDIR/.muttrc"
    # ln -fs "$($READLINK -f .zshrc)" "$CONFDIR/.zshrc"

	# have to do something different for alacritty
	mkdir -p "$CONFDIR/.config/alacritty"
	if grep -q "Darwin" <<< "$uname_v"; then
		ln -fs "$($READLINK -f config/alacritty/alacritty-mac.yml)" "$CONFDIR/.config/alacritty/alacritty.yml"
	else
		ln -fs "$($READLINK -f config/alacritty/alacritty.yml)" "$CONFDIR/.config/alacritty/alacritty.yml"
	fi

	vim +PlugClean +qall
	vim +PlugInstall +qall
}

install_fzf() {
	git clone --depth 1 git@github.com:junegunn/fzf ~/.fzf
	~/.fzf/install
}

install_fd() {
    if grep -q "Darwin" <<< "$uname_v"; then
        brew install fd
    elif grep -q "Arch" <<< "$uname_v"; then
        pacman -S fd
    elif hash apt 2>/dev/null; then
        # latest version as of 3/10/2020
        # unfortunately it's only in the repos as of 19.10
        wget https://github.com/sharkdp/fd/releases/download/v7.4.0/fd_7.4.0_amd64.deb
        sudo dpkg -i fd_7.4.0_amd64.deb
        rm fd_7.4.0_amd64.deb
    elif hash dnf 2>/dev/null; then
        dnf install fd-find
    fi
}

install_neofetch() {
	if grep -q "Arch" <<< "$uname_v"; then
		yaourt -S neofetch-git
	elif hash apt 2>/dev/null; then
		sudo apt install neofetch
	elif hash dnf 2>/dev/null; then
		dnf copr enable konimex/neofetch
		dnf install neofetch
    elif grep -q "Darwin" <<< "$uname_v"; then
        brew install neofetch
	fi
}

install_ag() {
	if grep -q "Arch" <<< "$uname_v"; then
		pacman -S the_silver_searcher
	elif hash apt 2>/dev/null; then
		sudo apt install silversearcher-ag
	elif hash dnf 2>/dev/null; then
		dnf install the_silver_searcher
    elif grep -q "Darwin" <<< "$uname_v"; then
        brew install the_silver_searcher
	fi
}

install_brew() {
    if ! hash brew 2> /dev/null ; then
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
    fi

    brew install coreutils
    READLINK="$(which greadlink)"
}

usage() {
	printf "%s\n" "Usage: ./setup.sh [OPTIONS]"
	printf "%s\n" "Examples: ./setup.sh -b $HOME/bin"
	printf "%s\n" "          ./setup.sh"
	printf "%s\n" "Options:"
	printf "%s\n" "-b /path/to/bin    Install dir. Default is $HOME/bin."
	printf "%s\n" "-c /config/dir     Directory for configs. Default is $HOME."
	printf "%s\n" "-h                 Print this help."
	printf "%s\n" "NOTE: This script may need to be run with 'sudo' if"
	printf "%s\n" "you are not root."
}

get_args() {
	bin_set=0
	conf_set=0
	while getopts ":c:b:h" opt; do
		case $opt in
			b)
				if [[ $bin_set -eq 0 ]]; then
					bin_set=1
					BINDIR=$OPTARG
					printf "%s\n" "install location: $OPTARG"
				else
					error_trig "'-b' provided too many times. Run with '-h' for help"
				fi
				;;
			c)
				if [[ $conf_set -eq 0 ]]; then
					conf_set=1
					CONFDIR=$OPTARG
					printf "%s\n" "config location: $OPTARG"
				else
					error_trig "'-c' provided too many times. Run with '-h' for help"
				fi
				;;
			h)
				usage
				exit 0
				;;
			\?)
				error_trig "Invalid option: $OPTARG. Run with '-h' for help"
				;;
			:)
				error_trig "$OPTARG must be run with a directory name. Run with '-h' for help"
				;;
		esac
	done
}

main() {
    #error_trig "uncomment the functions that should be run for this machine"

    get_args "$@"
    path_check

	# uncomment everything that should be done with this script

    # if on a mac, need to install some utilities that don't come default
    if grep -q "Darwin" <<< "$uname_v"; then
        install_brew
    fi
    #install_scripts
    #install_vim
    #install_vim_final
    install_configs
    # install_ag
    # install_fzf
    # install_neofetch
    # install_fd

	printf "done.\n"
}

main "$@"
