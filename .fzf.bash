# Setup fzf
# ---------
if [[ ! "$PATH" == */home/dev/.fzf/bin* ]]; then
  PATH="${PATH:+${PATH}:}/home/dev/.fzf/bin"
fi

# Auto-completion
# ---------------
source "/home/dev/.fzf/shell/completion.bash"

# Key bindings
# ------------
# source "/home/dev/.fzf/shell/key-bindings.bash"
