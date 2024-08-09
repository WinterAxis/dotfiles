# Setup fzf
# ---------
if [[ ! "$PATH" == */home/dev/.fzf/bin* ]]; then
  PATH="${PATH:+${PATH}:}/home/dev/.fzf/bin"
fi

eval "$(fzf --bash)"
