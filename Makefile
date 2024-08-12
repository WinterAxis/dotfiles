SHELL := /bin/bash

LAZYGIT_VERSION = $(shell curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": \"v\K[^"]*')

all: dotfiles tools
	source ~/.bashrc

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
	@echo "Checking if ~/.tmux/plugins/tpm already exists..."
	@if [ -d ~/.tmux/plugins/tpm ]; then \
		echo "Warning: ~/.tmux/plugins/tpm already exists. Skipping clone."; \
	else \
		echo "Cloning TPM..."; \
		git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm; \
	fi

# Tools
tools: lazygit fzf

lazygit:
	@echo "Checking if lazygit is already installed..."
	@if command -v lazygit >/dev/null 2>&1; then \
		echo "lazygit is already installed. Skipping installation."; \
	else \
		echo "Installing lazygit..."; \
		curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"; \
		tar xf lazygit.tar.gz lazygit; \
		sudo install lazygit ~/.local/bin/; \
		rm lazygit lazygit.tar.gz; \
	fi

fzf:
	@echo "Checking if ~/.fzf already exists..."
	@if [ -d ~/.fzf ]; then \
		echo "Warning: ~/.fzf already exists. Skipping clone."; \
		rm -f ~/.fzf.bash; \
	else \
		echo "Cloning fzf..."; \
		git clone --depth 1 "https://github.com/junegunn/fzf.git" ~/.fzf; \
	fi
	@echo "Running fzf installer..."
	(echo y; echo y; echo n;) | ~/.fzf/install
	rm -f ~/.fzf.bash
	ln -sf ~/dotfiles/.fzf.bash ~/.fzf.bash

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
clean: clean-bashrc clean-inputrc clean-starship clean-nvim clean-tmux clean-fzf clean-lazygit

