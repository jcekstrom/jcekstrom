set nocompatible               " be iMproved
filetype off                   " required!

set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

" let Vundle manage Vundle
" required! 
Bundle 'gmarik/vundle'

" My Bundles here:
"
" original repos on github
Bundle 'tpope/vim-fugitive'
Bundle 'kien/ctrlp.vim'
" vim-scripts repos
Bundle 'L9'
" non github repos
" Bundle 'git://git.wincent.com/command-t.git'
" ...
Bundle "scrooloose/nerdtree"

filetype plugin indent on     " required!
"
" Brief help
" :BundleList          - list configured bundles
" :BundleInstall(!)    - install(update) bundles
" :BundleSearch(!) foo - search(or refresh cache first) for foo
" :BundleClean(!)      - confirm(or auto-approve) removal of unused bundles
"
" see :h vundle for more details or wiki for FAQ
" NOTE: comments after Bundle command are not allowed..

" Section: Options {{{1
" ---------------------

set nocompatible
set autoindent
set autowrite       " Automatically save before commands like :next and :make
if has("balloon_eval") && has("unix")
  set ballooneval
endif
if exists("&breakindent")
  set breakindent showbreak=+++
endif
set cmdheight=2
set commentstring=#\ %s
set complete-=i     " Searching includes can be slow
set display=lastline
if has("eval")
  let &fileencodings = substitute(&fileencodings,"latin1","cp1252","")
endif
set fileformats=unix,dos,mac
set grepprg=grep\ -rnH\ --exclude='.*.swp'\ --exclude='*~'\ --exclude=tags
if has("eval")
  let &highlight = substitute(&highlight,'NonText','SpecialKey','g')
endif
set incsearch       " Incremental search
set laststatus=2    " Always show status line
set lazyredraw
if (&termencoding ==# 'utf-8' || &encoding ==# 'utf-8') && version >= 700
  let &listchars = "tab:\u21e5\u00b7,trail:\u2423,extends:\u21c9,precedes:\u21c7,nbsp:\u26ad"
  let &fillchars = "vert:\u259a,fold:\u00b7"
else
  set listchars=tab:>\ ,trail:-,extends:>,precedes:<
endif
set mousemodel=popup
set pastetoggle=<F2>
set scrolloff=1
set showcmd         " Show (partial) command in status line.
set showmatch       " Show matching brackets.
set smartcase       " Case insensitive searches become sensitive with capitals
set smarttab        " sw at the start of the line, sts everywhere else
if exists("+spelllang")
  set spelllang=en_us
endif
set spellfile=~/.vim/spell/en.utf-8.add
set splitbelow      " Split windows at bottom
set statusline=[%n]\ %<%.99f\ %h%w%m%r%{SL('CapsLockStatusline')}%y%{SL('fugitive#statusline')}%#ErrorMsg#%{SL('SyntasticStatuslineFlag')}%*%=%-14.(%l,%c%V%)\ %P
" set suffixes+=.aux,.dvi,.swo  " Lower priority in wildcards
set tags+=../tags;/
set timeoutlen=1200 " A little bit more time for macros
set ttimeoutlen=50  " Make Esc work faster
if exists('+undofile')
  set undofile
endif
if v:version >= 700
  set viminfo=!,'20,<50,s10,h
endif
set visualbell
set virtualedit=block
set wildmenu
set wildmode=longest:full,full
set wildignore+=tags
set winaltkeys=no

if v:version >= 600
  set autoread
  set foldmethod=marker
  set printoptions=paper:letter
  set sidescrolloff=5
  set mouse=nvi
endif


if !has("gui_running") && $DISPLAY == '' || !has("gui")
  set mouse=
endif

if $TERM =~ '^screen'
  if exists("+ttymouse") && &ttymouse == ''
    set ttymouse=xterm
  endif
  if $TERM != 'screen.linux' && &t_Co == 8
    set t_Co=16
  endif
endif

if has("dos16") || has("dos32") || has("win32") || has("win64")
  if $PATH =~? 'cygwin' && ! exists("g:no_cygwin_shell")
    set shell=bash
    set shellpipe=2>&1\|tee
    set shellslash
  endif
elseif has("mac")
  set backupskip+=/private/tmp/*
endif

" Plugin Settings {{{2

if v:version >= 700
let g:is_bash = 1
let g:sh_noisk = 1
let g:markdown_fenced_languages = ['ruby', 'html', 'javascript', 'css', 'erb=eruby.html', 'bash=sh', 'sh']
let g:liquid_highlight_types = g:markdown_fenced_languages + ['jinja=liquid', 'html+erb=eruby.html', 'html+jinja=liquid.html']
let g:spellfile_URL = 'http://ftp.vim.org/vim/runtime/spell'

let g:CSApprox_verbose_level = 0
let g:ctrlp_user_command = ['.git/', 'git --git-dir=%s/.git ls-files -oc --exclude-standard']
let g:NERDTreeHijackNetrw = 0
let g:ragtag_global_maps = 1
let g:space_disable_select_mode = 1
let g:VCSCommandDisableMappings = 1
let g:showmarks_enable = 0
let g:surround_{char2nr('-')} = "<% \r %>"
let g:surround_{char2nr('=')} = "<%= \r %>"
let g:surround_{char2nr('8')} = "/* \r */"
let g:surround_{char2nr('s')} = " \r"
let g:surround_{char2nr('^')} = "/^\r$/"
let g:surround_indent = 1

function! s:try(cmd, default)
  if exists(':' . a:cmd) && !v:count
    let tick = b:changedtick
    exe a:cmd
    if tick == b:changedtick
      execute 'normal! '.a:default
    endif
  else
    execute 'normal! '.v:count.a:default
  endif
endfunction

nnoremap <silent> gJ :<C-U>call <SID>try('SplitjoinJoin', 'gJ')<CR>
nnoremap <silent>  J :<C-U>call <SID>try('SplitjoinJoin', 'J')<CR>
nnoremap <silent> gS :SplitjoinSplit<CR>
nnoremap <silent>  S :<C-U>call <SID>try('SplitjoinSplit', 'S')<CR>
nnoremap <silent> r<CR> :<C-U>call <SID>try('SplitjoinSplit', "r\015")<CR>

endif

" }}}2
" Section: Commands {{{1
" -----------------------

if has("eval")
function! SL(function)
  if exists('*'.a:function)
    return call(a:function,[])
  else
    return ''
  endif
endfunction

command! -bar -nargs=1 -complete=file E :exe "edit ".substitute(<q-args>,'\(.*\):\(\d\+\):\=$','+\2 \1','')
command! -bar -nargs=? -bang Scratch :silent enew<bang>|set buftype=nofile bufhidden=hide noswapfile buflisted filetype=<args> modifiable
command! -bar -count=0 RFC     :e http://www.ietf.org/rfc/rfc<count>.txt|setl ro noma
function! s:scratch_maps() abort
  nnoremap <silent> <buffer> == :Scratch<CR>
  nnoremap <silent> <buffer> =" :Scratch<Bar>put<Bar>1delete _<Bar>filetype detect<CR>
  nnoremap <silent> <buffer> =* :Scratch<Bar>put *<Bar>1delete _<Bar>filetype detect<CR>
  nnoremap          <buffer> =f :Scratch<Bar>setfiletype<Space>
endfunction

function! Synname()
  if exists("*synstack")
    return map(synstack(line('.'),col('.')),'synIDattr(v:val,"name")')
  else
    return synIDattr(synID(line('.'),col('.'),1),'name')
  endif
endfunction

command! -bar Invert :let &background = (&background=="light"?"dark":"light")

function! Fancy()
  if &number
    if has("gui_running")
      let &columns=&columns-12
    endif
    windo set nonumber foldcolumn=0
    if exists("+cursorcolumn")
      set nocursorcolumn nocursorline
    endif
  else
    if has("gui_running")
      let &columns=&columns+12
    endif
    windo set number foldcolumn=4
    if exists("+cursorcolumn")
      set cursorline
    endif
  endif
endfunction
command! -bar Fancy :call Fancy()

function! OpenURL(url)
  if has("win32")
    exe "!start cmd /cstart /b ".a:url.""
  elseif $DISPLAY !~ '^\w'
    exe "silent !tpope browse \"".a:url."\""
  elseif exists(':Start')
    exe "Start tpope browse -T \"".a:url."\""
  else
    exe "!tpope browse -T \"".a:url."\""
  endif
  redraw!
endfunction
command! -nargs=1 OpenURL :call OpenURL(<q-args>)
" open URL under cursor in browser
nnoremap gb :OpenURL <cfile><CR>
nnoremap gA :OpenURL http://www.answers.com/<cword><CR>
nnoremap gG :OpenURL http://www.google.com/search?q=<cword><CR>
nnoremap gW :OpenURL http://en.wikipedia.org/wiki/Special:Search?search=<cword><CR>

function! Run()
  let cmd = matchstr(getline(1),'^#!\zs[^ ]*')
  if exists('b:run_command')
    exe b:run_command
  elseif cmd != '' && executable(cmd)
    wa
    let cmd = matchstr(getline(1),'^#!\zs.*').' %'
    if exists(':Dispatch')
      execute 'Dispatch '.cmd
    else
      execute '!'.cmd
    endif
  elseif &ft == 'mail' || &ft == 'text' || &ft == 'help' || &ft == 'gitcommit'
    setlocal spell!
  elseif exists('b:rails_root') && exists(':Rake')
    wa
    Rake
  elseif &ft == 'ruby' && b:dispatch =~# '-Wc'
    wa
    if executable('pry') && exists('b:rake_root')
      execute '!pry -I"'.b:rake_root.'/lib" -r"%:p"'
    elseif executable('pry')
      !pry -r"%:p"
    else
      !irb -r"%:p"
    endif
  elseif exists('b:dispatch') && b:dispatch =~# '^:.'
    execute b:dispatch
  elseif exists(':Dispatch') && exists('b:dispatch')
    Dispatch
  elseif exists('b:dispatch')
    execute '!'.b:dispatch
  endif
  return ''
endfunction
command! -bar Run :execute Run()

  0verbose runtime! plugin/matchit.vim
  0verbose runtime! macros/matchit.vim
endif

" Section: Mappings {{{1
" ----------------------

if has('digraphs')
  digraph ./ 8230
endif

nnoremap Y  y$
if exists(":nohls")
  nnoremap <silent> <C-L> :nohls<CR><C-L>
endif
inoremap <C-C> <Esc>`^

vnoremap     <M-<> <gv
vnoremap     <M->> >gv
vnoremap     <Space> I<Space><Esc>gv

inoremap <C-X>^ <C-R>=substitute(&commentstring,' \=%s\>'," -*- ".&ft." -*- vim:set ft=".&ft." ".(&et?"et":"noet")." sw=".&sw." sts=".&sts.':','')<CR>

cnoremap <C-O>      <Up>
inoremap <M-o>      <C-O>o
inoremap <M-O>      <C-O>O
inoremap <M-i>      <Left>
inoremap <M-I>      <C-O>^
inoremap <M-A>      <C-O>$
noremap! <C-J>      <Down>
noremap! <C-K><C-K> <Up>
if has("eval")
  command! -buffer -bar -range -nargs=? Slide :exe 'norm m`'|exe '<line1>,<line2>move'.((<q-args> < 0 ? <line1>-1 : <line2>)+(<q-args>=='' ? 1 : <q-args>))|exe 'norm ``'
endif

map  <F1>   <Esc>
map! <F1>   <Esc>
if has("gui_running")
  map <F2>  :Fancy<CR>
endif
nmap <silent> <F6> :if &previewwindow<Bar>pclose<Bar>elseif exists(':Gstatus')<Bar>exe 'Gstatus'<Bar>else<Bar>ls<Bar>endif<CR>
nmap <silent> <F7> :if exists(':Lcd')<Bar>exe 'Lcd'<Bar>elseif exists(':Cd')<Bar>exe 'Cd'<Bar>else<Bar>lcd %:h<Bar>endif<CR>
map <F8>    :Make<CR>
map <F9>    :Dispatch<CR>
map <F10>   :Start<CR>

noremap  <S-Insert> <MiddleMouse>
noremap! <S-Insert> <MiddleMouse>

imap <C-L>          <Plug>CapsLockToggle
imap <C-G>c         <Plug>CapsLockToggle
nmap du             <Plug>SpeedDatingNowUTC
nmap dx             <Plug>SpeedDatingNowLocal
map <Leader>v  :so ~/.vimrc<CR>

inoremap <silent> <C-G><C-T> <C-R>=repeat(complete(col('.'),map(["%Y-%m-%d %H:%M:%S","%a, %d %b %Y %H:%M:%S %z","%Y %b %d","%d-%b-%y","%a %b %d %T %Z %Y"],'strftime(v:val)')+[localtime()]),0)<CR>

" Section: Autocommands {{{1
" --------------------------

if has("autocmd")
  filetype plugin indent on

  augroup Misc " {{{2
    autocmd!

    autocmd FileType netrw nnoremap <buffer> gr :grep <C-R>=shellescape(fnamemodify(expand('%').'/'.getline('.'),':.'),1)<CR><Home><C-Right> -r<Space>
    autocmd FileType netrw call s:scratch_maps()
    autocmd FileType gitcommit if getline(1)[0] ==# '#' | call s:scratch_maps() | endif
    autocmd FocusLost   * silent! wall
    autocmd FocusGained * if !has('win32') | silent! call fugitive#reload_status() | endif
    autocmd SourcePre */macros/less.vim set laststatus=0 cmdheight=1
    if v:version >= 700 && isdirectory(expand("~/.trash"))
      autocmd BufWritePre,BufWritePost * if exists("s:backupdir") | set backupext=~ | let &backupdir = s:backupdir | unlet s:backupdir | endif
      autocmd BufWritePre ~/*
            \ let s:path = expand("~/.trash").strpart(expand("<afile>:p:~:h"),1) |
            \ if !isdirectory(s:path) | call mkdir(s:path,"p") | endif |
            \ let s:backupdir = &backupdir |
            \ let &backupdir = escape(s:path,'\,').','.&backupdir |
            \ let &backupext = strftime(".%Y%m%d%H%M%S~",getftime(expand("<afile>:p")))
    endif

    autocmd User Rails let b:dispatch = ':Rake' | let b:start = ':Rserver'
    autocmd User Fugitive
          \ if filereadable(fugitive#buffer().repo().dir('fugitive.vim')) |
          \   source `=fugitive#buffer().repo().dir('fugitive.vim')` |
          \ endif

    autocmd BufNewFile */init.d/*
          \ if filereadable("/etc/init.d/skeleton") |
          \   keepalt read /etc/init.d/skeleton |
          \   1delete_ |
          \ endif |
          \ set ft=sh

    autocmd BufReadPost * if getline(1) =~# '^#!' | let b:dispatch = getline(1)[2:-1] . ' %' | let b:start = b:dispatch | endif
    autocmd BufReadPost ~/.Xdefaults,~/.Xresources let b:dispatch = 'xrdb -load %'
    autocmd BufWritePre,FileWritePre /etc/* if &ft == "dns" |
          \ exe "normal msHmt" |
          \ exe "gl/^\\s*\\d\\+\\s*;\\s*Serial$/normal ^\<C-A>" |
          \ exe "normal g`tztg`s" |
          \ endif
    autocmd CursorHold,BufWritePost,BufReadPost,BufLeave *
      \ if !$VIMSWAP && isdirectory(expand("<amatch>:h")) | let &swapfile = &modified | endif
  augroup END " }}}2
  augroup FTCheck " {{{2
    autocmd!
    autocmd BufNewFile,BufRead *named.conf*       set ft=named
    autocmd BufNewFile,BufRead *.txt,README,INSTALL,NEWS,TODO if &ft == ""|set ft=text|endif
  augroup END " }}}2
  augroup FTOptions " {{{2
    autocmd!
    autocmd FileType c,cpp,cs,java          setlocal commentstring=//\ %s
    autocmd Syntax   javascript             setlocal isk+=$
    autocmd FileType xml,xsd,xslt,javascript setlocal ts=2
    autocmd FileType text,txt,mail          setlocal ai com=fb:*,fb:-,n:>
    autocmd FileType sh,zsh,csh,tcsh        inoremap <silent> <buffer> <C-X>! #!/bin/<C-R>=&ft<CR>
    autocmd FileType sh,zsh,csh,tcsh        let &l:path = substitute($PATH, ':', ',', 'g')
    autocmd FileType perl,python,ruby       inoremap <silent> <buffer> <C-X>! #!/usr/bin/env<Space><C-R>=&ft<CR>
    autocmd FileType c,cpp,cs,java,perl,javscript,php,aspperl,tex,css let b:surround_101 = "\r\n}"
    autocmd FileType apache       setlocal commentstring=#\ %s
    autocmd FileType cucumber let b:dispatch = 'cucumber %' | imap <buffer><expr> <Tab> pumvisible() ? "\<C-N>" : (CucumberComplete(1,'') >= 0 ? "\<C-X>\<C-O>" : (getline('.') =~ '\S' ? ' ' : "\<C-I>"))
    autocmd FileType git,gitcommit setlocal foldmethod=syntax foldlevel=1
    autocmd FileType gitcommit setlocal spell
    autocmd FileType gitrebase nnoremap <buffer> S :Cycle<CR>
    autocmd FileType help setlocal ai fo+=2n | silent! setlocal nospell
    autocmd FileType help nnoremap <silent><buffer> q :q<CR>
    autocmd FileType html setlocal iskeyword+=~ | let b:dispatch = ':OpenURL %'
    autocmd FileType java let b:dispatch = 'javac %'
    autocmd FileType lua  setlocal includeexpr=substitute(v:fname,'\\.','/','g').'.lua'
    autocmd FileType perl let b:dispatch = 'perl -Wc %'
    autocmd FileType ruby setlocal tw=79 comments=:#\  isfname+=:
    autocmd FileType ruby
          \ let b:start = executable('pry') ? 'pry -r "%:p"' : 'irb -r "%:p"' |
          \ if expand('%') =~# '_test\.rb$' |
          \   let b:dispatch = 'testrb %' |
          \ elseif expand('%') =~# '_spec\.rb$' |
          \   let b:dispatch = 'rspec %' |
          \ else |
          \   let b:dispatch = 'ruby -wc %' |
          \ endif
    autocmd FileType liquid,markdown,text,txt setlocal tw=78 linebreak nolist
    autocmd FileType tex let b:dispatch = 'latex -interaction=nonstopmode %' | setlocal formatoptions+=l
    autocmd FileType vim  setlocal keywordprg=:help |
          \ if exists(':Runtime') |
          \   let b:dispatch = ':Runtime' |
          \   let b:start = ':Runtime|PP' |
          \ else |
          \   let b:dispatch = ":unlet! g:loaded_{expand('%:t:r')}|source %" |
          \ endif
    autocmd FileType timl let b:dispatch = ':w|source %' | let b:start = b:dispatch . '|TLrepl'
    autocmd FileType * if exists("+omnifunc") && &omnifunc == "" | setlocal omnifunc=syntaxcomplete#Complete | endif
    autocmd FileType * if exists("+completefunc") && &completefunc == "" | setlocal completefunc=syntaxcomplete#Complete | endif
  augroup END "}}}2
endif " has("autocmd")

" }}}1
" Section: Visual {{{1
" --------------------

" Switch syntax highlighting on, when the terminal has colors
if (&t_Co > 2 || has("gui_running")) && has("syntax")
  function! s:initialize_font()
    if exists("&guifont")
      if has("mac")
        set guifont=Monaco:h12
      elseif has("unix")
        if &guifont == ""
          set guifont=bitstream\ vera\ sans\ mono\ 10
        endif
      elseif has("win32")
        set guifont=Consolas:h11,Courier\ New:h10
      endif
    endif
  endfunction

  command! -bar -nargs=0 Bigger  :let &guifont = substitute(&guifont,'\d\+$','\=submatch(0)+1','')
  command! -bar -nargs=0 Smaller :let &guifont = substitute(&guifont,'\d\+$','\=submatch(0)-1','')
  noremap <M-,>        :Smaller<CR>
  noremap <M-.>        :Bigger<CR>

  if exists("syntax_on") || exists("syntax_manual")
  else
    syntax on
  endif
  set list
  if !exists('g:colors_name')
    if filereadable(expand("~/.vim/colors/tim.vim"))
      colorscheme tim
    elseif filereadable(expand("~/.vim/colors/tpope.vim"))
      colorscheme tpope
    endif
  endif

  augroup RCVisual
    autocmd!

    autocmd VimEnter *  if !has("gui_running") | set background=dark notitle noicon | endif
    autocmd GUIEnter *  set background=light title icon cmdheight=2 lines=25 columns=80 guioptions-=T guioptions-=m guioptions-=e guioptions-=r guioptions-=L
    autocmd GUIEnter *  if has("diff") && &diff | set columns=165 | endif
    autocmd GUIEnter *  silent! colorscheme vividchalk
    autocmd GUIEnter *  call s:initialize_font()
    autocmd GUIEnter *  let $GIT_EDITOR = 'false'
    autocmd Syntax sh   syn sync minlines=500
    autocmd Syntax css  syn sync minlines=50
    autocmd Syntax csh  hi link cshBckQuote Special | hi link cshExtVar PreProc | hi link cshSubst PreProc | hi link cshSetVariables Identifier
  augroup END
endif

" }}}1
if filereadable(expand("~/.vimrc.local"))
  source ~/.vimrc.local
endif


syntax on
set sw=4
set ts=4
set softtabstop=4
set expandtab
