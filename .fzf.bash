# Setup fzf
# ---------
if [[ ! "$PATH" == *~/.fzf/bin* ]]; then
  PATH="${PATH:+${PATH}:}~/.fzf/bin"
fi

# Auto-completion
# ---------------
if [ -f ~/.fzf/shell/completion.bash ]; then
  source ~/.fzf/shell/completion.bash
fi

# Key bindings
# ------------
# source "~/.fzf/shell/key-bindings.bash"
