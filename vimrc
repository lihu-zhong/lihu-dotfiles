set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

" More intelligent line numbers
Plugin 'myusuf3/numbers.vim'
" Status bar with useful info
Plugin 'vim-airline/vim-airline'
" in-editor linting
Plugin 'vim-syntastic/syntastic'
" Easier commenting out lines
Plugin 'scrooloose/nerdcommenter'
" Easier directory navigation from within vim
Plugin 'scrooloose/nerdtree'
" Display git status inline on directory tree
Plugin 'Xuyuanp/nerdtree-git-plugin'
" Display git status of specific lines within vim
Plugin 'airblade/vim-gitgutter'
" yaml syntax highlighting (mediocre, tbh, but the best I could find)
Plugin 'chase/vim-ansible-yaml'
" Enhanced python syntax highlighting
Plugin 'vim-python/python-syntax'
" Repeat motions with counts
Plugin 'Houl/repmo-vim'
" Jinja2 syntax highlighter
Plugin 'Glench/Vim-Jinja2-Syntax'
" git wrapper for vim
Plugin 'tpope/vim-fugitive'
" Python formatter
Plugin 'psf/black'
" Python documetation
Plugin 'davidhalter/jedi-vim'
" TOML syntax highlighting
Plugin 'cespare/vim-toml'


" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line
set laststatus=2
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:python_highlight_all = 1

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 0
let g:syntastic_check_on_open = 0
let g:syntastic_check_on_wq = 0
let g:syntanstic_auto_jump = 0
let g:syntastic_aggregate_errors = 1
let g:syntastic_python_checkers = ['pylint', 'mypy']
let g:syntastic_python_mypy_args = "--ignore-missing-imports --no-strict-optional"
let g:syntastic_shell_checkers = ['shellcheck']
let g:syntastic_yaml_checkers = ['yamllint']
let g:syntastic_rst_checkers = ['sphinx']

" Toggle location list. Super useful for syntastic
function! ToggleErrors()
    let old_last_winnr = winnr('$')
    lclose
    if old_last_winnr == winnr('$')
        " Nothing was closed, open syntastic error location panel
        Errors
    endif
endfunction

nnoremap <Leader>e :call ToggleErrors()<Enter>

" NERDTree settings
" Open NERDTree when opening vim
"autocmd vimenter * NERDTree
" Sane toggle key
nnoremap <Leader>f :NERDTreeToggle<Enter>
" Close NERDTree when opening a file
let NERDTreeQuitOnOpen = 1
" Disable help message
let NERDTreeMinimalUI = 1
let NERDTreeDirArrows = 1

set colorcolumn=73,89
highlight ColorColumn ctermbg=239 guibg=Grey30
set nowrap
set sidescroll=1

" I literally never want an indent to be anything other than 4 spaces
filetype plugin indent on
" show existing tab with 4 spaces width
set tabstop=4
set softtabstop=4
" when indenting with '>', use 4 spaces width
set shiftwidth=4
" On pressing tab, insert 4 spaces
set expandtab

" Indent yaml with 2 spaces
autocmd FileType yaml setlocal shiftwidth=2 tabstop=2 softtabstop=2

" Fold on indents in yaml files
autocmd FileType yaml setlocal foldmethod=indent

" Allow folding in python, but not by default
autocmd FileType python setlocal foldmethod=indent
autocmd FileType python setlocal foldlevel=99

" My white cursor shows up poorly on a bright yellow background
set hlsearch
hi Search ctermbg=DarkBlue
hi Search ctermfg=LightYellow

"Make nerdtree open splits to the right
set splitright

"Save and close buffer
command Wbd write|bdelete

"repmo doesn't have default mappings :(
" map a motion and its reverse motion:
:noremap <expr> h repmo#SelfKey('h', 'l')|sunmap h
:noremap <expr> l repmo#SelfKey('l', 'h')|sunmap l

" if you like `:noremap j gj', you can keep that:
:map <expr> j repmo#Key('gj', 'gk')|sunmap j
:map <expr> k repmo#Key('gk', 'gj')|sunmap k

" repeat the last [count]motion or the last zap-key:
:map <expr> ; repmo#LastKey(';')|sunmap ;
:map <expr> , repmo#LastRevKey(',')|sunmap ,

" add these mappings when repeating with `;' or `,':
:noremap <expr> f repmo#ZapKey('f')|sunmap f
:noremap <expr> F repmo#ZapKey('F')|sunmap F
:noremap <expr> t repmo#ZapKey('t')|sunmap t
:noremap <expr> T repmo#ZapKey('T')|sunmap T

"With argument, you can make `f` remember the count (same for `F`, `t` and `T`):
:noremap <expr> f repmo#ZapKey('f', 1)|sunmap f

"Scroll commands work too:
:noremap <expr> <C-E> repmo#SelfKey('<C-E>', '<C-Y>')
:noremap <expr> <C-Y> repmo#SelfKey('<C-Y>', '<C-E>')

"Alternative repetition keys (also working in addition to `;` and `,`):
" repeat the last [count]motion:
:map <expr> <Space> repmo#LastKey('')|sunmap <Space>
:map <expr> <BS>    repmo#LastRevKey('')|sunmap <BS>

"If non-zero, a repetition key like `;` only repeats the last motion for
"which a count was given.  This used to be the only available option.
"If zero, `;` repeats any last motion, this is the new default!
:let g:repmo_require_count = 1

" Turn off autocomplete
let g:jedi#completions_enabled = 0
" Have jedi use splits
let g:jedi#use_splits_not_buffers = "right"
" Don't show call signatures
let g:jedi#show_call_signatures = "0"
" Don't autocomplete imports
let g:jedi#smart_auto_mappings = 0

" Prevent bad autotabbing
autocmd FileType python setlocal indentkeys-=<:>
autocmd FileType python setlocal indentkeys-=:
autocmd FileType yaml setlocal indentkeys-=<:>
autocmd FileType yaml setlocal indentkeys-=:

" Better vimdiff colors
highlight DiffAdd ctermbg=52
highlight DiffChange ctermbg=54
highlight DiffText ctermbg=125

" Default to extended regular expressions ("very magic")
noremap / /\v

noremap <Leader><Space> :Black<Enter>:w<Enter>

" Persistent Undo
set undofile
set undodir=$HOME/.vim/undodir

" Enable syntastic tabline with buffer number
let g:airline#extensions#tabline#enabled=1
let g:airline#extensions#tabline#buffer_nr_show=1

" Easier buffer navigation
noremap gl :bn<Enter>
noremap gL :bp<Enter>

" Don't require saving before switching buffers
set hidden

" Easy opening of buffers in vertical splits
cabbrev vb vert sb

" Rename tabs to show tab number.
" (Based on http://stackoverflow.com/questions/5927952/whats-implementation-of-vims-default-tabline-function)
if exists("+showtabline")
    function! MyTabLine()
        let s = ''
        let wn = ''
        let t = tabpagenr()
        let i = 1
        while i <= tabpagenr('$')
            let buflist = tabpagebuflist(i)
            let winnr = tabpagewinnr(i)
            let s .= '%' . i . 'T'
            let s .= (i == t ? '%1*' : '%2*')
            let s .= ' '
            let wn = tabpagewinnr(i,'$')

            let s .= '%#TabNum#'
            let s .= i
            " let s .= '%*'
            let s .= (i == t ? '%#TabLineSel#' : '%#TabLine#')
            let bufnr = buflist[winnr - 1]
            let file = bufname(bufnr)
            let buftype = getbufvar(bufnr, 'buftype')
            if buftype == 'nofile'
                if file =~ '\/.'
                    let file = substitute(file, '.*\/\ze.', '', '')
                endif
            else
                let file = fnamemodify(file, ':p:t')
            endif
            if file == ''
                let file = '[No Name]'
            endif
            let s .= ' ' . file . ' '
            let i = i + 1
        endwhile
        let s .= '%T%#TabLineFill#%='
        let s .= (tabpagenr('$') > 1 ? '%999XX' : 'X')
        return s
    endfunction
    set stal=2
    set tabline=%!MyTabLine()
    set showtabline=1
    highlight link TabNum Special
endif
