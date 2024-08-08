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
