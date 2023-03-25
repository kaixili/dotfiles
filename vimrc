"
" ██╗   ██╗██╗███╗   ███╗
" ██║   ██║██║████╗ ████║
" ██║   ██║██║██╔████╔██║
" ╚██╗ ██╔╝██║██║╚██╔╝██║
"  ╚████╔╝ ██║██║ ╚═╝ ██║
"   ╚═══╝  ╚═╝╚═╝     ╚═╝
" [[
"    github.com/kaixili
"    2018/12/09
" ]]

" Vim-Plug Auto Installation {{{
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif
" }}}
" Plug Manager {{{
call plug#begin('~/.vim/plugged')

" Vim
Plug 'ctrlpvim/ctrlp.vim'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }

" UI
Plug 'joshdick/onedark.vim'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'mhinz/vim-startify'       " Start screen
Plug 'sheerun/vim-polyglot'     " A collection of language packs for Vim
Plug 'airblade/vim-gitgutter'
" Plug 'roman/golden-ratio'
Plug 'scrooloose/nerdtree'
Plug 'chrisbra/Colorizer'

" Move
Plug 'easymotion/vim-easymotion'
Plug 'christoomey/vim-tmux-navigator'
Plug 'justinmk/vim-sneak'

" Edit
Plug 'tpope/vim-surround'       " Easily delete, change and add such surroundings in pairs.
Plug 'scrooloose/nerdcommenter' " Fast commented
Plug 'junegunn/vim-easy-align'
Plug 'honza/vim-snippets'
Plug 'tpope/vim-repeat'
Plug 'terryma/vim-multiple-cursors'
Plug 'ntpeters/vim-better-whitespace'

" Lint
Plug 'w0rp/ale'

" Cpp
Plug 'vim-scripts/a.vim', { 'for': 'cpp' } " Alternate Files quickly (.c --> .h etc)

" Complete
Plug 'jiangmiao/auto-pairs'
" Plug 'shougo/neocomplete'
" Plug 'Valloric/YouCompleteMe'
" Dark powered asynchronous completion framework for neovim/Vim8
" if has('nvim')
"   Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
" else
"   Plug 'Shougo/deoplete.nvim'
"   Plug 'roxma/nvim-yarp'
"   Plug 'roxma/vim-hug-neovim-rpc'
" endif
" Plug 'zchee/deoplete-clang'
" Plug 'Shougo/neoinclude.vim'
" Plug 'autozimu/LanguageClient-neovim', {
"    \ 'branch': 'next',
"    \ 'do': 'bash install.sh',
"    \ }

" Initialize plugin system
call plug#end()
" }}}

" User Setting
""""""""""""""""
" Colorscheme {{{
set termguicolors
set background=dark   " require
syntax enable
colorscheme onedark
" }}}
" Misc {{{
set undodir=~/.vim/undodir      " Persistent Undo
set nocompatible
set synmaxcol=200
set scrolloff=3                 " Minimum lines to keep above and below cursor
set backspace=indent,eol,start
set laststatus=2
set statusline=\ %{HasPaste()}%F%m%r%h\ %w\ \ CWD:\ %r%{getcwd()}%h\ \ \ Line:\ %l\ \ Column:\ %c
" disable Background Color Erase (BCE) so that color schemes
" render properly when inside 256-color tmux and GNU screen.
" see also http://snk.tuxfamily.org/log/vim-256color-bce.html
" https://sunaku.github.io/vim-256color-bce.html#solution
if &term =~ '256color'
    set t_ut=
endif
" remember last position
if has("autocmd")
  au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif
" }}}
" Shell {{{
set shell=/bin/zsh
autocmd BufWinEnter,WinEnter term://* startinsert
set splitbelow
set splitright
" }}}
" Indent {{{
set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab
set smarttab
filetype indent on
filetype plugin on
set autoindent
" }}}
" UI {{{
" Disable scrollbars
set guioptions-=r
set guioptions-=R
set guioptions-=l
set guioptions-=L

set ttyfast     " Speed up
set showcmd
set wildmenu
set number
set lazyredraw
set nocursorline " highlight current line
set nowrap
set fillchars+=vert:┃
" }}}
" Folding {{{
set foldenable          " enable folding
set foldmethod=indent   " fold based on indent level
set foldnestmax=10      " max 10 depth
set modelines=1         " tell Vim to check just the final line of the file for a modeline
set foldlevelstart=10   " start with fold level of 1
" }}}
" Search {{{
set smartcase
set incsearch   " search as characters are entered
set hlsearch    " highlight matches
set showmatch   " highlight matching [{()}]
set ignorecase  " ignore case when searching
" }}}
" Leader Map Shortcuts {{{
let mapleader="\<Space>"
" Smart way to move between windows
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l
"
" Useful mappings for managing tabs
map <C-n>      :tabnew<cr>
map <leader>tn :tabnew<cr>
map <leader>to :tabonly<cr>
map <leader>tc :tabclose<cr>
map <leader>tm :tabmove
map <leader>tt :tabnext<cr>
map <Tab>      :tabnext<cr>

" Fast Jump
map <C-a> <Home>
map <C-e> <End>
" Let 'tl' toggle between this and the last accessed tab
let g:lasttab = 1
nmap <Leader>tl :exe "tabn ".g:lasttab<CR>
au TabLeave * let g:lasttab = tabpagenr()
" }}}
" User Function {{{
command WW w !sudo tee % > /dev/null
command W w
command Wq wq
command Q q
set pastetoggle=<F3>
" }}}

" Plugin Setting
""""""""""""""""
" Ale {{{
let g:ale_linters = {
            \   'python': ['flake8'],
            \   'C++': ['clang-format', 'clang', 'cppcheck'],
            \   'C': ['clang-format', 'clang', 'cppcheck'],
            \   'CUDA': ['nvcc'],
            \   'LUA': ['luac'],
            \}
let g:ale_fix_on_save = 1
let g:ale_lint_on_text_changed = 'never'
let g:ale_sign_column_always = 1
let g:ale_echo_msg_error_str = 'Error'
let g:ale_echo_msg_warning_str = 'Warn'
let g:ale_echo_msg_format = '[%linter%] %s [%severity%]'

let g:ale_cpp_clang_options = '-std=c++17 -Wall'
let g:ale_cpp_clangformat_options = '-std=c++17 -Wall'
let g:ale_c_clang_options = '-std=c++17 -Wall'
let g:ale_c_clangformat_options = '-std=c++17 -Wall'
" }}}
" Ycm {{{
let g:ycm_global_ycm_extra_conf        = '~/.vim/plugged/YouCompleteMe/third_party/ycmd/.ycm_extra_conf.py'
let g:ycm_key_list_select_completion   = ['<C-n>', '<C-j>']
let g:ycm_key_list_previous_completion = ['<C-p>', '<C-k>']
let g:deoplete#enable_at_startup       = 1
nnoremap <leader>gl :YcmCompleter GoToDeclaration<CR>
nnoremap <leader>gf :YcmCompleter GoToDefinition<CR>
nnoremap <leader>gg :YcmCompleter GoToDefinitionElseDeclaration<CR>
" }}}
" Ctrlp {{{
let g:ctrlp_match_window = 'bottom,order:ttb'
let g:ctrlp_switch_buffer = 0
let g:ctrlp_working_path_mode = 0
let g:ctrlp_custom_ignore = '\vbuild/|dist/|venv/|target/|\.(o|swp|pyc|egg)$'
" }}}
" Airline {{{
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#show_tabs = 1
let g:airline#extensions#tabline#show_buffers = 1
let g:airline#extensions#tabline#formatter = 'unique_tail_improved'
let g:airline_theme='onedark'
" }}}
" NERDTree {{{
map <F4> :NERDTreeToggle<CR>
autocmd StdinReadPre * let s:std_in=1
" open a NERDTree automatically when vim starts up if no files were specified
" autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
" open NERDTree automatically when vim starts up on opening a directory
autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in") | exe 'NERDTree' argv()[0] | wincmd p | ene | endif
" close vim if the only window left open is a NERDTree
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
" }}}
" NeoComplete {{{
"Note: This option must be set in .vimrc(_vimrc).  NOT IN .gvimrc(_gvimrc)!
" Disable AutoComplPop.
let g:acp_enableAtStartup = 0
" Use neocomplete.
let g:neocomplete#enable_at_startup = 1
" Use smartcase.
let g:neocomplete#enable_smart_case = 1
" Set minimum syntax keyword length.
let g:neocomplete#sources#syntax#min_keyword_length = 3

" Define dictionary.
let g:neocomplete#sources#dictionary#dictionaries = {
    \ 'default' : '',
    \ 'vimshell' : $HOME.'/.vimshell_hist',
    \ 'scheme' : $HOME.'/.gosh_completions'
        \ }

" Define keyword.
if !exists('g:neocomplete#keyword_patterns')
    let g:neocomplete#keyword_patterns = {}
endif
let g:neocomplete#keyword_patterns['default'] = '\h\w*'

" Plugin key-mappings.
inoremap <expr><C-g>     neocomplete#undo_completion()
inoremap <expr><C-l>     neocomplete#complete_common_string()

" Recommended key-mappings.
" <CR>: close popup and save indent.
inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
function! s:my_cr_function()
  return (pumvisible() ? "\<C-y>" : "" ) . "\<CR>"
  " For no inserting <CR> key.
  "return pumvisible() ? "\<C-y>" : "\<CR>"
endfunction
" <TAB>: completion.
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
" <C-h>, <BS>: close popup and delete backword char.
inoremap <expr><C-h> neocomplete#smart_close_popup()."\<C-h>"
inoremap <expr><BS> neocomplete#smart_close_popup()."\<C-h>"
" Close popup by <Space>.
"inoremap <expr><Space> pumvisible() ? "\<C-y>" : "\<Space>"

" AutoComplPop like behavior.
"let g:neocomplete#enable_auto_select = 1

" Shell like behavior(not recommended).
"set completeopt+=longest
"let g:neocomplete#enable_auto_select = 1
"let g:neocomplete#disable_auto_complete = 1
"inoremap <expr><TAB>  pumvisible() ? "\<Down>" : "\<C-x>\<C-u>"

" Enable omni completion.
autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags

" Enable heavy omni completion.
if !exists('g:neocomplete#sources#omni#input_patterns')
  let g:neocomplete#sources#omni#input_patterns = {}
endif
"let g:neocomplete#sources#omni#input_patterns.php = '[^. \t]->\h\w*\|\h\w*::'
"let g:neocomplete#sources#omni#input_patterns.c = '[^.[:digit:] *\t]\%(\.\|->\)'
"let g:neocomplete#sources#omni#input_patterns.cpp = '[^.[:digit:] *\t]\%(\.\|->\)\|\h\w*::'

" For perlomni.vim setting.
" https://github.com/c9s/perlomni.vim
let g:neocomplete#sources#omni#input_patterns.perl = '\h\w*->\h\w*\|\h\w*::'
" }}}
" Easy align{{{
" [count]vipga
" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)
" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)
" }}}
" Colorizer {{{
let g:colorizer_auto_filetype = 'css,html,lua,md'
let g:colorizer_syntax        = 1
"}}}
" Deoplete {{{
let g:deoplete#enable_at_startup = 1
" }}}
"  NERD Commenter {{{
"  [count]<leader>cc |NERDComComment|
"  [count]<leader>cu |Undo|
"  [count]<leader>c<space> |NERDComToggleComment|
" Add spaces after comment delimiters by default
let g:NERDSpaceDelims = 1
" Use compact syntax for prettified multi-line comments
let g:NERDCompactSexyComs = 1
" Align line-wise comment delimiters flush left instead of following code indentation
let g:NERDDefaultAlign = 'left'
" Set a language to use its alternate delimiters by default
let g:NERDAltDelims_java = 1
" Add your own custom formats or override the defaults
let g:NERDCustomDelimiters = { 'c': { 'left': '/**','right': '*/' } }
" Allow commenting and inverting empty lines (useful when commenting a region)
let g:NERDCommentEmptyLines = 1
" Enable trimming of trailing whitespace when uncommenting
let g:NERDTrimTrailingWhitespace = 1
" Enable NERDCommenterToggle to check all selected lines is commented or not
let g:NERDToggleCheckAllLines = 1
" }}}
" Language Client NeoVim {{{
" Required for operations modifying multiple buffers like rename.
set hidden
"let g:LanguageClient_serverCommands = {
"    \ 'rust': ['~/.cargo/bin/rustup', 'run', 'stable', 'rls'],
"    \ 'javascript': ['/usr/local/bin/javascript-typescript-stdio'],
"    \ 'javascript.jsx': ['tcp://127.0.0.1:2089'],
"    \ 'python': ['/usr/local/bin/pyls'],
"    \ }
nnoremap <F5> :call LanguageClient_contextMenu()<CR>
" Or map each action separately
nnoremap <silent> K :call LanguageClient#textDocument_hover()<CR>
nnoremap <silent> gd :call LanguageClient#textDocument_definition()<CR>
nnoremap <silent> <F2> :call LanguageClient#textDocument_rename()<CR>
" }}}
" Better Whitespace {{{
let g:better_whitespace_enabled=1
let g:strip_whitespace_on_save=1
" }}}

" vim:foldmethod=marker:foldlevel=0
