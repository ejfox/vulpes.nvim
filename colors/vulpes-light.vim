" Vulpes Light - A cyberpunk neon colorscheme (light variant)
" https://github.com/ejfox/vulpes.nvim
"
" Maintainer: EJ Fox <ejfox@ejfox.com>
" License: MIT

highlight clear
if exists('syntax_on')
  syntax reset
endif

set background=light
let g:colors_name = 'vulpes-light'

" Neovim: use Lua implementation
if has('nvim')
  set termguicolors
  lua require('vulpes').load({ variant = 'light' })
  finish
endif

" Vim: require termguicolors
if !has('termguicolors')
  echoerr 'vulpes requires termguicolors'
  finish
endif
set termguicolors

" Vim fallback (basic support)
" For full experience, use Neovim 0.8+

" Core colors
let s:bg = '#fefefe'
let s:fg = '#1a0a10'
let s:base = '#c50058'
let s:comment = '#008b8f'
let s:keyword = '#d60080'
let s:string = '#2a1520'
let s:number = '#d60090'
let s:type = '#c50070'
let s:error = '#ff0040'
let s:warning = '#cc8800'

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
