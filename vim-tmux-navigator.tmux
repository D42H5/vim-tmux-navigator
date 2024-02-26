#!/usr/bin/env bash

version_pat='s/^tmux[^0-9]*([.0-9]+).*/\1/p'

is_vim="ps -o state= -o comm= -t '#{pane_tty}' \
    | grep -iqE '^[^TXZ ]+ +(\\S+\\/)?g?(view|l?n?vim?x?|fzf)(diff)?$'"
tmux bind-key -n M-a if-shell "$is_vim" "send-keys M-a" "select-pane -L"
tmux bind-key -n M-s if-shell "$is_vim" "send-keys M-s" "select-pane -D"
tmux bind-key -n M-d if-shell "$is_vim" "send-keys M-d" "select-pane -U"
tmux bind-key -n M-f if-shell "$is_vim" "send-keys M-f" "select-pane -R"
tmux_version="$(tmux -V | sed -En "$version_pat")"
tmux setenv -g tmux_version "$tmux_version"

#echo "{'version' : '${tmux_version}', 'sed_pat' : '${version_pat}' }" > ~/.tmux_version.json

tmux if-shell -b '[ "$(echo "$tmux_version < 3.0" | bc)" = 1 ]' \
  "bind-key -n 'C-\\' if-shell \"$is_vim\" 'send-keys C-\\'  'select-pane -l'"
tmux if-shell -b '[ "$(echo "$tmux_version >= 3.0" | bc)" = 1 ]' \
  "bind-key -n 'C-\\' if-shell \"$is_vim\" 'send-keys C-\\\\'  'select-pane -l'"

tmux bind-key -T copy-mode-vi M-a select-pane -L
tmux bind-key -T copy-mode-vi M-s select-pane -D
tmux bind-key -T copy-mode-vi M-d select-pane -U
tmux bind-key -T copy-mode-vi M-f select-pane -R
tmux bind-key -T copy-mode-vi C-\\ select-pane -l
