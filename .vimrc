" General configuration {{{

set gcr=a:blinkon0              "Disable cursor blink
" detect .tex files...somehow disabled
autocmd BufRead,BufNewFile *.tex set filetype=tex
" }}}

"""""""""""""""""""""""" VUNDLE SETUP {{{
set nocompatible              " be iMproved, required
filetype off                  " required
" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

" Keep Plugin commands between vundle#begin/end.

" plugin on GitHub repo
Plugin 'tpope/vim-fugitive'

" plugin from http://vim-scripts.org/vim/scripts.html
Plugin 'L9'

" Pass the path to set the runtimepath properly.
Plugin 'rstacruz/sparkup', {'rtp': 'vim/'}

" vim-airline
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'

" vim-multiple-cursors
Plugin 'terryma/vim-multiple-cursors'

" vim-r
"Bundle 'vim-scripts/Vim-R-plugin'
"set runtimepath-=~/.vim/bundle/Vim-R-plugin "disable Vim-R temporarily, supplanted by Nvim-R

"Nvim-R
"Bundle 'jalvesaq/Nvim-R'


" vim-toml syntax highlighting
Plugin 'cespare/vim-toml'

" Faster fold 
Plugin 'Konfekt/FastFold'

" SimpylFold
Plugin 'tmhedberg/SimpylFold'

" Slime
Plugin 'jpalardy/vim-slime'

" seoul256 colorscheme
"Plugin 'junegunn/seoul256.vim'

" space vim dark theme 
Plugin 'liuchengxu/space-vim-dark'

" Pathogen
execute pathogen#infect()

" vimtex
"Plugin 'lervag/vimtex'


"" UltiSnips
" Track the engine.
"Plugin 'SirVer/ultisnips'

" Snippets are separated from the engine. Add this if you want them:
"Plugin 'honza/vim-snippets'

" Conque-GDB, using gdb in vim buffer
"Plugin 'vim-scripts/Conque-GDB'

" YouCompleteMe
Plugin 'Valloric/YouCompleteMe'

" Supertab
"Plugin 'ervandew/supertab'


" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
" filetype plugin on
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line
""""""""""""""""""""""""}}}
" auto complete
inoremap ( ()<Left>
inoremap (<CR>  (<CR>)<Esc>O<Tab>
inoremap ((     (
inoremap ()     ()

inoremap [ []<Left>
inoremap [<CR>  [<CR>]<Esc>O<Tab>
inoremap []     []

inoremap { {}<Left>
"inoremap {<CR>  {<CR>}<Esc>O<Tab>
inoremap {{     {
inoremap {}     {}

inoremap " ""<Left>
inoremap "" "
inoremap ' ''<Left>
inoremap '' '

" autoindent
set autoindent
"set smartindent
inoremap {<CR>  {<CR><BS>}<Esc>ko
" Python format
au BufNewFile,BufRead *.py
    \ set tabstop=2 |
    \ set softtabstop=2 |
    \ set shiftwidth=2 |
    \ set expandtab |
    \ set autoindent |
    \ set fileformat=unix 

" Enable folding
set foldmethod=indent
set foldlevel=99

" share clipboard
set clipboard=unnamed

" search and replace selected text
vnoremap <C-r> "hy:%s/<C-r>h//g<left><left>
vnoremap // y/<C-R>"<CR>

"""""""""""""""""""""""" Visual "{{{
" Set the guifont
set guifont=Menlo:h12

" vim-multiple-cursors
" Default mapping
let g:multi_cursor_next_key='<C-n>'
let g:multi_cursor_prev_key='<C-p>'
let g:multi_cursor_skip_key='<C-x>'
let g:multi_cursor_quit_key='<Esc>'

" Solarized theme
syntax enable 

let g:solarized_termcolors=256
" let g:solarized_termtrans = 1 "vim_not transparent on terminal
colorscheme solarized  

"colorscheme seoul256
"let g:seoul256_background = 236
"colo seoul256
"set background=dark

"colorscheme space-vim-dark
"let g:space_vim_dark_background = 234
"color space-vim-dark
"hi Comment cterm=italic
" make background transparent
"hi Normal guibg=NONE ctermbg=NONE
"hi Normal ctermbg=none
"hi NonText ctermbg=none
"hi LineNr ctermbg=none

set splitbelow
set splitright
" Case-insensitive search
"set ignorecase
" Highlight search results
"set hlsearch
"
" highlight matching [{()}]
"set showmatch

" Show line numbers
set number
" Show column numbers
set ruler

" Turn off vim-R assign
"let vimrplugin_assign = 0

" Column 80 marker
" setlocal textwidth=80
" setlocal colorcolumn=81
" Highlight Colorcolumn (also see ~/.vim/ftplugin/txt.vim)
" highlight ColorColumn guibg=DodgerBlue4


" R script settings
"let maplocalleader = ","
"vmap <Space> <Plug>RDSendSelection
"nmap <Space> <Plug>RDSendLine
"let vimrplugin_applescript=0
"let vimrplugin_vsplit=1

"vim-airlines"
let g:airline_powerline_fonts = 1
set laststatus=2
"let g:airline_theme="solarized"
let g:airline_theme="light"
let g:airline#extensions#tabline#enabled = 1
"let g:airline#extensions#tabline#buffer_nr_show = 1
let g:airline#extensions#tabline#show_tab_nr = 1
let g:airline#extensions#tabline#tab_nr_type = 1
let g:airline#extensions#tabline#show_splits = 0
let g:airline#extensions#tabline#show_buffers = 0
"let g:airline_theme="zenburn"
"Powerline font symbol problems"
"set term=xterm-256color    "not work
"set termencoding=utf-8     "not work
""put this in .gvimrc   "(this works)
set guifont=Meslo\ LG\ S\ Regular\ for\ Powerline:h12 
set encoding=utf-8

"Syntastic"
"set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*
let g:syntastic_mode_map={'mode': 'passive'}
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 0
let g:syntastic_check_on_wq = 0
let g:syntastic_quiet_messages = { "level" : "warnings" }
"r checker
let g:syntastic_r_checkers = ['lintr']
let g:syntastic_rmd_checkers = ['lintr']
let g:syntastic_enable_r_lintr_checker = 1
let g:syntastic_error_symbol = '✗'


" Fast fold settings
nmap zuz <Plug>(FastFoldUpdate)
let g:fastfold_savehook = 1
let g:fastfold_fold_command_suffixes =  ['x','X','a','A','o','O','c','C']
let g:fastfold_fold_movement_commands = [']z', '[z', 'zj', 'zk']

let g:tex_fold_enabled=1
let g:vimsyn_folding='af'
let g:xml_syntax_folding = 1
let g:php_folding = 1
let g:perl_fold = 1

" Slime setting
let g:slime_target = "tmux"
let g:slime_default_config = {"socket_name": split($TMUX, ",")[0], "target_pane": ":.2"}
let g:slime_python_ipython = 1
xmap <Space> <Plug>SlimeRegionSend
nmap <CR> <Plug>SlimeParagraphSend
nmap <Space> <Plug>SlimeLineSend

""""""""""""""""""""""""}}}


""""""""""""""""""""""""Formatting "{{{
" Remember fold upon exit
augroup AutoSaveFolds
  autocmd!
  autocmd BufWinLeave * mkview
  autocmd BufWinEnter * silent loadview
augroup END

" disable error messages
set shortmess=at

" navigate split windows
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>


" enable syntax
let python_highlight_all=1
syntax on 
" Automatically detect file types."
filetype indent on 
" enable syntax processing
syntax enable 
" number of visual spaces per TAB
set tabstop=2  
" number of spaces in tab when editing
set softtabstop=0
set shiftwidth=2
" tabs are spaces
set expandtab
set smarttab
" set textwidth
"set textwidth=80
" Set linebreak 
set linebreak
set nocp 
" Set spell check
" Remove spell check
set nospell
"set spell spelllang=en_us
" Bash-style tab completion
set wildmode=longest,list
set wildmenu
" Allow backspace work properly
set backspace=indent,eol,start
""""""""""""""""""""""""}}}

""""""""""""""""""""""""Macros "{{{
" comment block
let @c='^I# '
" uncomment block
let @d='^lx'
""""""""""""""""""""""""}}}

"""""""""""""" vimtex plugin settings {{{
"let g:vimtex_latexmk_continuous=1
" }}}

"""""""""""""" Pandoc {{{
" source: https://github.com/lynnard/pandoc-preview.vim
"let g:pandoc_preview_pdf_cmd = "zathura"
"nnoremap <leader>V: PandocPreview<cr>
" }}}

"""""""""""""" UltiSnips {{{
" https://github.com/idbrii/vim-david-snippets/blob/master/UltiSnips/cpp.snippets
" Trigger configuration. Do not use <tab> if you use https://github.com/Valloric/YouCompleteMe.
"let g:UltiSnipsExpandTrigger="<tab>"
"let g:UltiSnipsJumpForwardTrigger="<c-b>"
"let g:UltiSnipsJumpBackwardTrigger="<c-z>"
" If you want :UltiSnipsEdit to split your window.
"let g:UltiSnipsEditSplit="vertical"
" }}}
