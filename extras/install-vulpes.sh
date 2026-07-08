#!/usr/bin/env bash
# install-vulpes.sh — drop the vulpes theme into every themeable tool.
# Works on Debian (native + WSL2) and macOS. Idempotent: re-run any time.
#
#   ./extras/install-vulpes.sh          # install everything it can find a home for
#   ./extras/install-vulpes.sh --dry    # print what it would do, touch nothing
#
# It only WRITES theme files. Turning the theme ON (one line per tool) is printed
# at the end — we don't edit your existing configs out from under you.

set -euo pipefail

EXTRAS="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CFG="${XDG_CONFIG_HOME:-$HOME/.config}"
DRY=0
[ "${1:-}" = "--dry" ] && DRY=1

say()  { printf '  %s\n' "$*"; }
step() { printf '\n\033[1m%s\033[0m\n' "$*"; }

# copy SRC -> DEST, making the parent dir. respects --dry.
put() {
  local src="$1" dest="$2"
  if [ ! -f "$EXTRAS/$src" ]; then say "skip  $src (not in extras/)"; return; fi
  if [ "$DRY" = 1 ]; then say "would copy $src -> $dest"; return; fi
  mkdir -p "$(dirname "$dest")"
  cp "$EXTRAS/$src" "$dest"
  say "ok    $dest"
}

step "Terminals"
put vulpes-ghostty.conf   "$CFG/ghostty/themes/vulpes"
put vulpes-kitty.conf     "$CFG/kitty/vulpes.conf"
put vulpes-alacritty.toml "$CFG/alacritty/vulpes.toml"
put vulpes-wezterm.lua    "$CFG/wezterm/colors/vulpes.lua"

step "TUIs"
put vulpes.tmux           "$CFG/tmux/vulpes.tmux"
# yazi reads theme.toml directly (no include mechanism), so this is a real overwrite —
# back up any existing one first.
if [ "$DRY" = 0 ] && [ -f "$CFG/yazi/theme.toml" ]; then
  cp "$CFG/yazi/theme.toml" "$CFG/yazi/theme.toml.bak" && say "note  backed up existing yazi theme -> theme.toml.bak"
fi
put vulpes-yazi.toml      "$CFG/yazi/theme.toml"
put vulpes-lazygit.yml    "$CFG/lazygit/vulpes.yml"
put vulpes-fzf.sh         "$CFG/fzf/vulpes-fzf.sh"

step "bat"
if command -v bat >/dev/null 2>&1; then
  BAT_THEMES="$(bat --config-dir 2>/dev/null)/themes"
elif command -v batcat >/dev/null 2>&1; then
  BAT_THEMES="$(batcat --config-dir 2>/dev/null)/themes"
else
  BAT_THEMES="$CFG/bat/themes"
fi
put vulpes-bat.tmTheme "$BAT_THEMES/vulpes.tmTheme"
if [ "$DRY" = 0 ] && command -v bat >/dev/null 2>&1; then bat cache --build >/dev/null 2>&1 && say "ok    bat cache rebuilt"; fi
if [ "$DRY" = 0 ] && command -v batcat >/dev/null 2>&1; then batcat cache --build >/dev/null 2>&1 && say "ok    bat cache rebuilt"; fi

step "Turn it on — add these lines to each tool's config:"
cat <<EOF
  ghostty   ~/.config/ghostty/config      theme = vulpes
  kitty     ~/.config/kitty/kitty.conf    include vulpes.conf
  alacritty ~/.config/alacritty/*.toml    [general] import = ["~/.config/alacritty/vulpes.toml"]
  wezterm   ~/.wezterm.lua                config.color_scheme = 'vulpes'   (colors/vulpes.lua auto-loads)
  tmux      ~/.tmux.conf                  source-file ~/.config/tmux/vulpes.tmux
  yazi      (theme.toml is already the active theme)
  lazygit   ~/.config/lazygit/config.yml  merge the keys from vulpes.yml under gui.theme
  fzf       ~/.zshrc                      source ~/.config/fzf/vulpes-fzf.sh
  bat       ~/.config/bat/config          --theme=vulpes
  nvim      (install ejfox/vulpes.nvim, then: colorscheme vulpes)
EOF
say ""
say "Done. Native Windows? use install-vulpes.ps1 instead."
