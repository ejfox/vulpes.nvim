" Vulpes Light - A cyberpunk neon colorscheme (light variant)
" https://github.com/ejfox/vulpes.nvim

if exists('g:loaded_vulpes_light') | finish | endif
let g:loaded_vulpes_light = 1

set background=light
highlight clear
if exists('syntax_on')
  syntax reset
endif

let g:colors_name = 'vulpes-light'

if has('nvim')
  lua require('vulpes').load({ variant = 'light' })
  finish
endif

" Vim fallback
let s:bg = '#fefefe'
let s:fg = '#1a0a10'
let s:base = '#c50058'
let s:comment = '#008b8f'

exe 'hi Normal guifg=' . s:fg . ' guibg=' . s:bg
exe 'hi Comment guifg=' . s:comment . ' gui=italic'
exe 'hi Statement guifg=' . s:base
