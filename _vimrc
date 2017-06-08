set nocompatible              " be iMproved, required


set diffexpr=MyDiff()
function! MyDiff()
  let opt = '-a --binary '
  if &diffopt =~ 'icase' | let opt = opt . '-i ' | endif
  if &diffopt =~ 'iwhite' | let opt = opt . '-b ' | endif
  let arg1 = v:fname_in
  if arg1 =~ ' ' | let arg1 = '"' . arg1 . '"' | endif
  let arg2 = v:fname_new
  if arg2 =~ ' ' | let arg2 = '"' . arg2 . '"' | endif
  let arg3 = v:fname_out
  if arg3 =~ ' ' | let arg3 = '"' . arg3 . '"' | endif
  if $VIMRUNTIME =~ ' '
    if &sh =~ '\<cmd'
      if empty(&shellxquote)
        let l:shxq_sav = ''
        set shellxquote&
      endif
      let cmd = '"' . $VIMRUNTIME . '\diff"'
    else
      let cmd = substitute($VIMRUNTIME, ' ', '" ', '') . '\diff"'
    endif
  else
    let cmd = $VIMRUNTIME . '\diff'
  endif
  silent execute '!' . cmd . ' ' . opt . arg1 . ' ' . arg2 . ' > ' . arg3
  if exists('l:shxq_sav')
    let &shellxquote=l:shxq_sav
  endif
endfunction


filetype off                  " required

" set the runtime path to include Vundle and initialize
set runtimepath+=$vim/vimfiles/bundle/Vundle.vim
let mypath='$vim/vimfiles/bundle'
call vundle#begin(mypath)
Plugin 'VundleVim/Vundle.vim'

""""""""""
"spf13 setup start
""""""""""
"Plugin 'CRefVim'
"Plugin 'tacahiroy/ctrlp-funky'
"Plugin 'LargeFile'
"Plugin 'yonchu/accelerated-smooth-scroll'
"Plugin 'vimomni'
"Plugin 'UltiSnips'
"Plugin 'AutoFold.vim'
"Plugin 'popup_it'
"Plugin 'win-manager-Improved'
"Plugin 'The-NERD-tree'
"Plugin 'StringComplete'
"Plugin 'SnippetComplete'
"Plugin 'IComplete'
"Plugin 'CompleteHelper'
Plugin 'taglist.vim'
"Plugin 'Syntastic'
"Plugin 'Shougo/neocomplete.vim'
"Plugin 'ctrlp.vim'
Plugin 'surround.vim'
Plugin 'neocomplcache'
Plugin 'EasyMotion'
Plugin 'Tabular'
Plugin 'Brace-Complete-for-CCpp'
Plugin 'CmdlineComplete'
Plugin 'apt-complete.vim'
Plugin 'code_complete-new-update'
Plugin 'NERD_tree-Project'
Plugin 'winmanager'
Plugin 'The-NERD-Commenter'
Plugin 'bufexplorer.zip'
Plugin 'AutoClose'
"Plugin 'xptemplate'
Plugin 'mbbill/fencview'
Plugin 'a.vim'
"Plugin 'OmniCppComplete'
Plugin 'c.vim'
"Plugin 'AutoComplPop'
"Plugin 'TagHighLight'
Plugin 'ervandew/supertab'
"Plugin 'ZoomWin'
Plugin 'fontzoom.vim'
"Plugin 'xmledit'
"Plugin 'XML-Folding'
"Plugin 'XmlPretty'
Plugin 'Tagbar'
"Plugin 'taglist-plus'
"Plugin 'node.js'
"Plugin 'jsbeautify'
Plugin 'VimIM'
"Plugin 'python_match.vim'
"Plugin 'Pydiction'
Plugin 'davidhalter/jedi-vim'
"Plugin 'PySmell'
"Plugin 'dbext.vim'
""""""""""
"spf13 setup end
""""""""""

call vundle#end()            " required
filetype plugin indent on    " required
filetype plugin on
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" My own basic config
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if v:progname =~? "evim"
    finish
endif

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

" Platform
function! MySys()
    if has("win32")
	return "windows"
    else
	return "linux"
    endif
endfunction

function! SwitchToBuf(filename)
    "let fullfn = substitute(a:filename, "^\\~/", $HOME . "/", "")
    " find in current tab
    let bufwinnr = bufwinnr(a:filename)
    if bufwinnr != -1
	exec bufwinnr . "wincmd w"
	return
    else
	" find in each tab
	tabfirst
	let tab = 1
	while tab <= tabpagenr("$")
	    let bufwinnr = bufwinnr(a:filename)
	    if bufwinnr != -1
		exec "normal " . tab . "gt"
		exec bufwinnr . "wincmd w"
		return
	    endif
	    tabnext
	    let tab = tab + 1
	endwhile
	" not exist, new tab
	exec "tabnew " . a:filename
    endif
endfunction

set ruler		
set showcmd		
set showmode
set incsearch		
set showmatch

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
    filetype plugin indent on

    augroup vimrcEx
	au!
	autocmd FileType text setlocal textwidth=80

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
    command DiffOrig vert new | set bt=nofile | r ++edit # | 0d_ | diffthis
		\ | wincmd p | diffthis
endif

set shiftwidth=4
set tabstop=4
set softtabstop=4
set noexpandtab
if has("win32")
    au GUIEnter * simalt ~x
endif

if has('gui_running') && has("win32")
    map <F11> :call libcallnr("gvimfullscreen.dll", "ToggleFullScreen", 0)<CR>
	imap <F11> :call libcallnr("gvimfullscreen.dll", "ToggleFullScreen", 0)<CR>
endif

"set guifont=courier_new:h12
"set guifont=Microsoft_YaHei_Mono:h14
set guifont=YaHei_Consolas_Hybrid:h14
"set guifont=Source_Code_Pro:h14
set smarttab
set nowrap
set nobackup
syntax on
set linespace=2
set autoindent
set smartindent
"filetype plugin indent on
filetype plugin on
set nu
"set wildmode
set wildmenu
"colorscheme darkblue

"Set mapleader
let mapleader = ","
let g:C_MapLeader  = ','

"set cmdheight=2
nnoremap <leader>wj :wincmd j<cr>
nnoremap <leader>wk :wincmd k<cr>
nnoremap <leader>wh :wincmd h<cr>
nnoremap <leader>wl :wincmd l<cr>
nnoremap <leader>we :new .<cr>
nnoremap <leader>ve :vnew .<cr>

"Fast edit vimrc
if MySys() == 'linux'
    map <silent> <leader>ss :source ~/.vimrc<cr>
    map <silent> <leader>ee :call SwitchToBuf("~/.vimrc")<cr>
    "When .vimrc is edited, reload it
    autocmd! bufwritepost .vimrc source ~/.vimrc
elseif MySys() == 'windows'
    map <silent> <leader>ss :source $MYVIMRC<cr>
    map <silent> <leader>ee :call SwitchToBuf($MYVIMRC)<cr>
    autocmd! bufwritepost $MYVIMRC source $MYVIMRC
endif

set colorcolumn=80

set bsdir=buffer
set autochdir		"need this feature be compiled with"
"autocmd BufEnter * lcd %:p:h

map <C-F12> :!ctags -R --c++-kinds=+p --fields=+iaS --extra=+q .<CR>
set tags=.tags,./../tags,./**/tags
set fileencodings=ucs-bom,utf8,chinese,taiwan,japan,korea,default,ansi
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"winmanager settings
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:winManagerWindowLayout = "FileExplorer,BufExplorer|TagList"
let g:winManagerWidth = 30
"let g:defaultExplorer = 0
nmap <C-W><C-F> :FirstExplorerWindow<cr>
nmap <C-W><C-B> :BottomExplorerWindow<cr>
nmap <silent> <leader>wm :WMToggle<cr>

runtime macros/matchit.vim
set foldenable              " 开始折叠
set foldcolumn=0            " 设置折叠区域的宽度
setlocal foldlevel=1        " 设置折叠层数为
"set foldlevelstart=99       " 打开文件是默认不折叠代码

set foldclose=all          " 设置为自动关闭折叠                
nnoremap <space> @=((foldclosed(line('.')) < 0) ? 'zc' : 'zo')<CR>
" 用空格键来开关折叠
"autocmd filetype inc,lpr,pp:set filetype=pascal
"autocmd filetype pascal,pp:setlocal autoindent
au BufRead,BufNewFile *.pp,*.lpr,*.inc		set filetype=pascal
let g:Tlist_File_Fold_Auto_Close=1 

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

map <F4> :x<cr>
set laststatus=2
set statusline=%<%t\ %y[%{&ff}][%{&fenc}]%m%r%=%-14.(%l,%c%V%)\ %P
" let @"=""
set shortmess+=I
"let loaded_nerd_tree=1
set ignorecase smartcase
let g:tagbar_left = 1
nnoremap <silent> <F7> :TagbarToggle<CR>
set guioptions-=T
"set guioptions-=m
let g:SuperTabClosePreviewOnPopupClose = 1
let g:SuperTabDefaultCompletionType = "<c-n>"
let g:alternateExtensions_CPP = "inc,h,H,HPP,hpp,mqh"

" Use CTRL-S for saving, also in Insert mode
nnoremap <C-S>		:update<CR><Esc>
"vnoremap <C-S>		<C-C>:update<CR>
inoremap <C-S>		<ESC>:update<CR><esc>
"set cursorcolumn cursorline
nnoremap <Leader>f :CtrlPFunky<Cr>
" Initialise list by a word under cursor
nnoremap <Leader>u :execute 'CtrlPFunky ' . expand('<cword>')<Cr>
cmap <A-y> <Left>
cmap <A-o> <Right>
"cnoremap <Esc>h  <C-Left>
"cnoremap <Esc>l <C-Right>


" configure syntastic syntax checking to check on open as well as save
"let g:syntastic_check_on_open=1
"let g:syntastic_html_tidy_ignore_errors=[" proprietary attribute \"ng-"]
"let g:syntastic_always_populate_loc_list = 1
"let g:syntastic_auto_loc_list = 1
"let g:syntastic_check_on_wq = 0
"let g:syntastic_check_on_x = 0
"let g:syntastic_check_on_ZZ = 0
"let b:syntastic_skip_check = 1
"set statusline+=%#warningmsg#
"set statusline+=%{SyntasticStatuslineFlag()}
"set statusline+=%*

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"""""""""" acp AutoComplPop
let g:acp_ignorecaseOption = 1
let g:acp_behaviorKeywordLength = 1

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"""""""""" neocomplcache
let g:neocomplcache_enable_at_startup = 1


"调用AStyle程序，进行代码美化
func! MyCodeFormat()
    "取得当前光标所在行号
    let lineNum = line(".")
    "C源程序
    if &filetype == 'c'
	"执行调用外部程序的命令
	"exec "%! astyle -A3Lfpjk3NS"
	exec "%! astyle --style=allman"
	"H头文件(文件类型识别为cpp)，CPP源程序
    elseif &filetype == 'cpp'
	"执行调用外部程序的命令
	"exec "%! astyle -A3Lfpjk3NS"
	exec "%! astyle --style=allman"
	"JAVA源程序
    elseif &filetype == 'java'
	"执行调用外部程序的命令
	exec "%! astyle --style=allman"
	"exec "%! astyle -A2Lfpjk3NS"
    else 
	"提示信息
	echo "不支持".&filetype."文件类型。"
    endif
    "返回先前光标所在行
    exec lineNum
endfunc
"映射代码美化函数到Shift+f快捷键
"map <F2> <Esc>:call MyCodeFormat()<CR>

noremap <silent> <F8> :TlistToggle<CR>
let g:C_MapLeader  = ','
noremap <F3> :cnext<cr>
noremap <S-F3> :cprevious<cr>
"inoremap <C-CR> <C-n>
nnoremap <C-CR> A
inoremap <C-CR> <ESC>A
inoremap <C-Space> <C-N>

nnoremap <Leader>s3 :!start "C:\Program Files (x86)\Source Insight 3\Insight3.exe" -i +=expand(line(".")) %<CR>
map <Leader>n :next<CR>
set cursorline
"hi CursorLine  cterm=NONE   ctermbg=darkred ctermfg=white 
"highlight CursorLine font=YaHei_Consolas_Hybrid:h16
"highlight CursorLine gui=underline
let Tlist_JS_Settings = 'javascript;s:string;a:array;o:object;f:function'
"set list

nmap <Leader><Leader>s :update<CR>
imap <Leader><Leader>s <ESC>:update<CR>
map <Leader><Leader>c <ESC>:quit<CR>
"inoremap jk <ESC>
vnoremap <C-C> "+y

augroup myPython2
	au!
	au BufEnter,BufNewFile,BufFilePost *.py map <F5> :!python %<cr>
	set expandtab
	"au BufNewFile,BufEnter,BufFilePost *.py set makeprg=python\ %
	"au BufNewFile,BufEnter,BufFilePost *.py map <F5> :make<CR>
	au BufNewFile,BufEnter,BufFilePost *.py map <buffer> <leader>g :!python %<cr>
augroup END

augroup myC
    au!
	"autocmd BufNewFile,BufEnter,BufReadPost,BufRead *.h,*.c,*.cpp,*.cc set tags+=c:/TDM-GCC-32/include/tags
	autocmd BufNewFile,BufEnter,BufReadPost,BufRead *.h,*.c set tags+=c:/TDM-GCC-32/include/stdc.tags
	autocmd BufNewFile,BufEnter,BufReadPost,BufRead *.h,*.hpp,*.cpp,*.cc set tags+=c:/TDM-GCC-31/lib/gcc/mingw32/5.1.0/include/tags
	autocmd BufNewFile,BufEnter,BufReadPost,BufRead *.h,*.c,*.cpp,*.cc set path+=c:/TDM-GCC-32/include/**
	"修改c.vim中的编译选项设置 -std=c99"
	"let   g:C_CFlags = '-std=c99 -Wall -g -O0 -c'
	"autocmd BufNewFile,BufEnter,BufReadPost,BufRead *.c set makeprg=gcc\ -g\ %\ -lgdi32\ -mwindows
	autocmd BufNewFile,BufEnter,BufReadPost,BufRead *.c set makeprg=gcc\ -g\ %
	autocmd BufNewFile,BufEnter,BufReadPost,BufRead *.cpp,*.cc set makeprg=g++\ -g\ -std=c++11\ %
	autocmd BufNewFile,BufEnter,BufReadPost,BufRead *.c,*.cpp,*.cc map <F5> :make<CR>
	autocmd BufNewFile,BufEnter,BufReadPost,BufRead *.cpp,*.cc,*.c map <C-F5> :!a.exe<cr>
augroup END

augroup myJava
	au!
	autocmd BufNewFile,BufEnter,BufReadPost,BufRead *.java set makeprg=javac\ %
	autocmd BufNewFile,BufEnter,BufReadPost,BufRead *.java map <F5> :make<CR>
	autocmd BufNewFile,BufEnter,BufReadPost,BufRead *.java map <C-F5> :!java %:r<CR>
augroup END

"let g:sql_type_default = 'mysql'
"let g:dbext_default_type = 'MYSQL'
"let g:dbext_default_user = 'root'
"let g:dbext_default_passwd = 'root'
"let g:dbext_default_host = 'localhost'
"let g:dbext_default_srvname = 'mysql'
"let g:dbext_default_port = 3306
"let g:dbext_default_bin_path = 'c:\myprog\MySql\5.7\Server\bin'
"let g:dbext_default_profile_mysql = 'type=MYSQL:user=root:passwd=root:extra=--batch --raw --silent'
"let g:jedi#force_py_version = 3
"let g:jedi#show_call_signatures = 2
let g:jedi#pop_on_dot = 0
let g:jedi#show_call_signatures_delay = 0

set foldmethod=syntax       " 设置语法折叠
let g:vimim_cloud='sogou,baidu,qq'
let g:vimim_mode='dynamic'
