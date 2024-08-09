
all: dotfiles

# dotfiles 
dotfiles: | bashrc inputrc starship nvim tmux

bashrc: | starship inputrc
	ln -s ~/dotfiles/.bashrc ~/.bashrc
inputrc:
	ln -s ~/dotfiles/.inputrc ~/.inputrc
starship:
	ln -s ~/dotfiles/.config/starship.toml ~/.config/starship.toml
nvim:
	ln -s ~/dotfiles/.config/nvim ~/.config/nvim
tmux: 
	ln -s ~/dotfiles/.tmux.conf ~/.tmux.conf
	git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# Tools
#

LAZYGIT_VERSION = $(shell curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": \"v\K[^"]*')
lazygit:
	curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
	tar xf lazygit.tar.gz lazygit
	sudo install lazygit ~/.local/bin/
	rm lazygit lazygit.tar.gz

# vim: ts=4 sts=4 sw=4 et
