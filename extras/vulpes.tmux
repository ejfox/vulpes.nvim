# Vulpes colorscheme for tmux
# https://github.com/ejfox/vulpes.nvim
#
# Installation:
#   Copy to ~/.config/tmux/vulpes.tmux
#   Add to tmux.conf: source-file ~/.config/tmux/vulpes.tmux

# Status bar
set -g status-style "bg=#0d0d0d,fg=#f2cfdf"
set -g status-left-style "bg=#e60067,fg=#000000,bold"
set -g status-right-style "bg=#0d0d0d,fg=#735865"

# Window status
set -g window-status-style "bg=#0d0d0d,fg=#735865"
set -g window-status-current-style "bg=#e60067,fg=#000000,bold"
set -g window-status-activity-style "bg=#ffaa00,fg=#000000"
set -g window-status-bell-style "bg=#ff001e,fg=#000000"

# Pane borders
set -g pane-border-style "fg=#0d0d0d"
set -g pane-active-border-style "fg=#e60067"

# Message style
set -g message-style "bg=#e60067,fg=#000000,bold"
set -g message-command-style "bg=#0d0d0d,fg=#e60067"

# Mode style (copy mode, etc.)
set -g mode-style "bg=#6b1a3d,fg=#ffffff"

# Clock
set -g clock-mode-colour "#e60067"

# Bell
set -g visual-bell off
