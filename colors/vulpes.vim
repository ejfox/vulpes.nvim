" Vulpes - A cyberpunk neon colorscheme
" https://github.com/ejfox/vulpes.nvim
"
" Maintainer: EJ Fox <ejfox@ejfox.com>
" License: MIT

if exists('g:loaded_vulpes') | finish | endif
let g:loaded_vulpes = 1

set background=dark
highlight clear
if exists('syntax_on')
  syntax reset
endif

let g:colors_name = 'vulpes'

" Neovim handles everything in Lua
if has('nvim')
  lua require('vulpes').load()
  finish
endif

" Vim fallback (basic support)
" For full experience, use Neovim 0.8+

" Core colors
let s:bg = '#000000'
let s:fg = '#f2cfdf'
let s:base = '#e60067'
let s:comment = '#6eedf7'
let s:keyword = '#ff1aca'
let s:string = '#f5f5f5'
let s:number = '#ff33c5'
let s:type = '#ff24ab'
let s:error = '#a0f7fc'
let s:warning = '#ffaa00'

" Basic highlights for Vim
exe 'hi Normal guifg=' . s:fg . ' guibg=' . s:bg
exe 'hi Comment guifg=' . s:comment . ' gui=italic'
exe 'hi Constant guifg=' . s:number
exe 'hi String guifg=' . s:string
exe 'hi Identifier guifg=' . s:base
exe 'hi Statement guifg=' . s:keyword
exe 'hi Type guifg=' . s:type
exe 'hi Special guifg=' . s:base
exe 'hi Error guifg=' . s:error
exe 'hi Todo guifg=' . s:bg . ' guibg=' . s:warning
