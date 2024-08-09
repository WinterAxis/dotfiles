LAZYGIT_VERSION = $(shell curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": \"v\K[^"]*')

all: dotfiles tools

# dotfiles 
dotfiles: bashrc inputrc starship nvim tmux

bashrc: starship inputrc fzf
	ln -sf ~/dotfiles/.bashrc ~/.bashrc

inputrc:
	ln -sf ~/dotfiles/.inputrc ~/.inputrc

starship:
	ln -sf ~/dotfiles/.config/starship.toml ~/.config/starship.toml

nvim:
	ln -sf ~/dotfiles/.config/nvim ~/.config/nvim

tmux: 
	ln -sf ~/dotfiles/.tmux.conf ~/.tmux.conf
	git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# Tools
tools: lazygit fzf

lazygit:
	curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
	tar xf lazygit.tar.gz lazygit
	sudo install lazygit ~/.local/bin/
	rm lazygit lazygit.tar.gz

fzf:
	ln -sf ~/dotfiles/.fzf.bash ~/.fzf.bash
	git clone --depth 1 "https://github.com/junegunn/fzf.git" ~/.fzf
	(echo y; echo y; echo n) | ~/.fzf/install

# Clean up individual items
clean-bashrc:
	rm -f ~/.bashrc

clean-inputrc:
	rm -f ~/.inputrc

clean-starship:
	rm -f ~/.config/starship.toml

clean-nvim:
	rm -rf ~/.config/nvim

clean-tmux:
	rm -f ~/.tmux.conf
	rm -rf ~/.tmux/plugins/tpm

clean-fzf:
	rm -f ~/.fzf.bash
	rm -rf ~/.fzf

clean-lazygit:
	rm -f ~/.local/bin/lazygit

# Clean all items
clean-all: clean-bashrc clean-inputrc clean-starship clean-nvim clean-tmux clean-fzf clean-lazygit

