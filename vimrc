" Use Vim settings, rather than Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

let g:pathogen_disabled = ['snipMate']
call pathogen#infect()

runtime macros/matchit.vim

let mapleader = ","

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

set nobackup                        " do not keep a backup file, use versions instead
set nowritebackup
set directory=$HOME/.vim/tmp//,.    " Keep swap files in one location
set history=1000                    " keep 50 lines of command line history
set ruler                           " show the cursor position all the time
set showcmd                         " display incomplete commands
set incsearch                       " do incremental searching
set mouse=a ttymouse=xterm2         " enable the use of the mouse in terminals

set expandtab                       " Spaces instead of tabs
set tabstop=2                       " A tab is two colums
set softtabstop=2                   " Amount of columns for backspace
set shiftwidth=2                    " Amount of columns for indentation in n mode
set shortmess+=I                    " don't give the intro message when starting Vim :intro.
set smarttab

"set clipboard=unnamed               " clipboard integration
if has('mac')
  if $TMUX == ''
    set clipboard+=unnamed
  else
    set clipboard=unnamed
  endif
else
  set clipboard=unnamedplus
endif

set encoding=utf-8
set fileencoding=utf-8
set ttyfast
set term=screen-256color
set t_Co=256
set number
"set cursorline
set list
set listchars=tab:▷⋅,trail:⋅,nbsp:⋅ " Highlight trailing spaces
set wildmode=longest,list            " use bash-like completion in command mode

" set last part of current working directory as terminal-tab title
silent execute '!printf "\e]1;$(basename `pwd`)\a"'
auto VimLeave * :!printf "\e]1;bash\a"

" http://connermcd.com/blog/2012/10/01/extending-vim%27s-text-objects/
let pairs = { ":" : ":",
            \ "." : ".",
            \ "/" : "/",
            \ '\|' : '\|',
            \ "*" : "*",
            \ "-" : "-",
            \ "_" : "_" }

for [key, value] in items(pairs)
  exe "nnoremap ci".key." T".key."ct".value
  exe "nnoremap ca".key." F".key."cf".value
  exe "nnoremap vi".key." T".key."vt".value
  exe "nnoremap va".key." F".key."vf".value
  exe "nnoremap di".key." T".key."dt".value
  exe "nnoremap da".key." F".key."df".value
  exe "nnoremap yi".key." T".key."yt".value
  exe "nnoremap ya".key." F".key."yf".value
endfor

" Highlight the 101 column when exceeded
highlight ColorColumn ctermbg=166
call matchadd('ColorColumn', '\%101v', 100)

colorscheme sexy-railscasts-256

" Don't use Ex mode, use Q for formatting
map Q gq

" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
inoremap <C-U> <C-G>u<C-U>

" In many terminal emulators the mouse works just fine, thus enable it.
if has('mouse')
  set mouse=a
endif

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
endif

" Only do this part when compiled with support for autocommands.
if has("autocmd")
  " Kill all the whitespace
  autocmd BufWritePre *.ex,*.exs,*.rb,*.erb,*.js,*.md,Gemfile,Thorfile,Guardfile,Rakefile,.vimrc,.gitconfig,*.go,*.elm :%s/\s\+$//e

  " File recognition
  autocmd BufNewFile,BufRead Gemfile,Thorfile,Guardfile,Rakefile set filetype=ruby
  autocmd BufNewFile,BufRead *.hbs set filetype=html

  " Enable file type detection.
  " Use the default filetype settings, so that mail gets 'tw' set to 72,
  " 'cindent' is on in C files, etc.
  " Also load indent files, to automatically do language-dependent indenting.
  filetype plugin on
  filetype plugin indent on

  autocmd FileType go set nolist

  " Put these in an autocmd group, so that we can delete them easily.
  augroup vimrcEx
  au!

  " For all text files set 'textwidth' to 78 characters.
  autocmd FileType text setlocal textwidth=78

  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event handler
  " (happens when dropping a file on gvim).
  " Also don't do it when the mark is in the first line, that is the default
  " position when opening a file.
  autocmd BufReadPost *
    \ if line("'\"") > 1 && line("'\"") <= line("$") |
    \   exe "normal! g`\"" |
    \ endif

  augroup END

else

  set autoindent		" always set autoindenting on

endif " has("autocmd")

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis
		  \ | wincmd p | diffthis
endif

command! FormatJSON %!jq '.'
command! FormatXML execute '%!xmllint --format --recover - 2>/dev/null' | setfiletype xml

function! BookmarkFile()
  redir >> ~/.vims
  echo strftime("%Y-%m-%d %H:%M") . " - " . expand("%:p").':'.line('.')
  redir END
endfunction
:command! BookmarkFile :call BookmarkFile()

let g:rubytest_cmd_spec = "bundle exec rspec %p"
let g:rubytest_cmd_example = "bundle exec rspec %p:%c"
"let g:rubytest_cmd_spec = "zeus rspec %p"
"let g:rubytest_cmd_example = "zeus rspec %p:%c"

let g:ackprg = 'ag --nogroup --nocolor --column'

let g:ctrlp_custom_ignore = 'node_modules\|DS_Store\|git'
let g:ctrlp_user_command = 'ag %s -i --nocolor --nogroup --hidden
      \ --ignore .git
      \ --ignore .svn
      \ --ignore .hg
      \ --ignore .DS_Store
      \ --ignore node_modules
      \ -g ""'
let g:ctrlp_use_caching = 0


let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<c-b>"
let g:UltiSnipsJumpBackwardTrigger="<c-z>"

let g:tagbar_autofocus = 1
let g:tagbar_autoclose = 1
let g:tagbar_type_elixir = {
    \ 'ctagstype' : 'elixir',
    \ 'kinds' : [
        \ 'm:modules',
        \ 'c:callbacks',
        \ 'd:delegates',
        \ 'e:exceptions',
        \ 'i:implementations',
        \ 'a:macros',
        \ 'o:operators',
        \ 'p:protocols',
        \ 'f:functions'
    \ ],
    \ 'sort' : 0
\ }

let g:expand_region_text_objects = {
      \ 'iw'  :0,
      \ 'iW'  :0,
      \ 'i"'  :0,
      \ 'i''' :0,
      \ 'i]'  :1,
      \ 'ib'  :1,
      \ 'iB'  :1,
      \ 'il'  :0,
      \ 'ip'  :0,
      \ 'ie'  :0,
      \ }

" prepare search&replace with selected text
vnoremap <C-r> "hy:%s/<C-r>h//gc<left><left><left>

" prepare search with selected text
vnoremap <leader>F "hy:Ack '<C-r>h'

" explicit copy/paste to/from OSX clipboard (bypass tmux)
vnoremap <leader>y :w !pbcopy<CR><CR>
noremap <leader>p :r !pbpaste<CR><CR>

nmap <leader>cs :let @*=expand("%")<CR>
nmap <leader>cl :let @*=expand("%:p")<CR>

" "navigate to next/previous in quickfix list
noremap <leader>n :cnext<CR>
noremap <leader>p :cprevious<CR>
noremap <leader>c :cclose<CR>

noremap <leader>gb :GoBuild<CR>

nnoremap <leader><leader> <c-^>                         " Switch between the last two files
nmap <leader>e :NERDTreeToggle<CR>
nmap <leader>f :NERDTreeFind<CR>
map <Leader>s :w<CR>
map <Leader>q :q!<CR>
nmap <leader>b :TagbarToggle<CR>
nmap <leader>B :BookmarkFile<CR>
nnoremap <F2> :set paste!<CR>                           " toogle paste mode
nnoremap <F5> :!ctags -R<CR>
noremap <leader>j <C-W>j<C-W>_                          " minimize split views
noremap <leader>k <C-W>k<C-W>_
noremap <C-h> <C-w>h                                    " Split navigation
noremap <C-j> <C-w>j
noremap <C-k> <C-w>k
noremap <C-l> <C-w>l
noremap Q @q
nnoremap <leader>r :CtrlPBufTag<CR>
nnoremap <C-E> :e ~/.vimrc<CR>                          " edit vim config
" nnoremap <C-R> :source ~/.vimrc<CR>                     " reload vim config
map q: :q

" Automatically jump to end of text you pasted:
vnoremap <silent> y y`]
vnoremap <silent> p p`]
nnoremap <silent> p p`]

vmap v <Plug>(expand_region_expand)
vmap <C-v> <Plug>(expand_region_shrink)

" Use Enter and Backspace to jump to the beginning/end or certain line
"nnoremap <CR> G
nnoremap <BS> gg

" disable arrow keys
map <up> <nop>
map <down> <nop>
map <left> <nop>
map <right> <nop>
imap <up> <nop>
imap <down> <nop>
imap <left> <nop>
imap <right> <nop>


" vp doesn't replace paste buffer
function! RestoreRegister()
  let @" = s:restore_reg
  return ''
endfunction
function! s:Repl()
  let s:restore_reg = @"
  return "p@=RestoreRegister()\<cr>"
endfunction
vmap <silent> <expr> p <sid>Repl()

