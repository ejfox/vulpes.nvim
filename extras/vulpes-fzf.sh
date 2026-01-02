#!/bin/bash
# Vulpes colorscheme for fzf
# https://github.com/ejfox/vulpes.nvim
#
# Installation:
#   Source in your shell rc:
#     source ~/.config/fzf/vulpes-fzf.sh
#
#   Or set FZF_DEFAULT_OPTS directly

export FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS \
  --color=fg:#f2cfdf,bg:#000000,hl:#e60067 \
  --color=fg+:#ffffff,bg+:#6b1a3d,hl+:#ff277d \
  --color=info:#ff0095,prompt:#e60067,pointer:#e60067 \
  --color=marker:#ffaa00,spinner:#ff24ab,header:#6eedf7 \
  --color=border:#e60067,gutter:#000000"
