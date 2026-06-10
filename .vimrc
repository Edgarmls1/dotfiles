set number
set relativenumber
set noshowmode
set noruler
set background=dark
set signcolumn=yes
set cursorline
set scrolloff=10

filetype plugin indent on
set expandtab
set shiftwidth=4
set softtabstop=4
set tabstop=4
set smartindent

syntax on

let mapleader = " "

let s:plugin_dir = expand('~/vim/plugins')

function! s:ensure(repo)
    let name = split(a:repo, '/')[-1]
    let path = s:plugin_dir . '/' . name

    if !isdirectory(path)
        if !isdirectory(s:plugin_dir)
            call mkdir(s:plugin_dir, 'p')
        endif
        execute '!git clone --depth=1 https://github.com/' . a:repo . ' ' . shellescape(path)
    endif

    execute 'set runtimepath+=' . fnameescape(path)
endfunction

call s:ensure('LunarWatcher/auto-pairs')
call s:ensure('WolfgangMehner/bash-support')
call s:ensure('fxn/vim-monochrome')
call s:ensure('Bakudankun/qline.vim')
call s:ensure('vim-airline/vim-airline')
call s:ensure('vim-airline/vim-airline-themes')
call s:ensure('junegunn/fzf')
call s:ensure('junegunn/fzf.vim')
call s:ensure('ap/vim-buftabline')
call s:ensure('yegappan/lsp')

let g:loaded_airline = 1
let g:fzf_vim = {}

set termguicolors
set hidden
colorscheme monochrome

let lspOpts = #{autoHighlightDiags: v:true}
autocmd User LspSetup call LspOptionsSet(lspOpts)
let lspServers = [
      \ #{ name: 'rust-analyzer', filetype: ['rust'], path: 'rust-analyzer', args: [] },
      \ #{ name: 'gopls', filetype: ['go'], path: 'gopls', args: [] },
      \ #{ name: 'jdtls', filetype: ['java'], path: 'jdtls', args: [] },
      \ #{ name: 'clangd', filetype: ['c'], path: 'clangd', args: [] },
      \ #{ name: 'pyright', filetype: ['python'], path: 'pyright', args: [] },
      \ ]

autocmd User LspSetup call LspAddServer(lspServers)


nnoremap <leader>e :Ex<CR>
nnoremap <leader>t :terminal<CR>
nnoremap <leader>f :FZF<CR>
nnoremap <TAB> :bnext<CR>
nnoremap <S-TAB> :bprev<CR>
nnoremap gd :LspGotoDefinition<CR>
nnoremap gr :LspShowReferences<CR>
nnoremap K  :LspHover<CR>
nnoremap gl :LspDiag current<CR>
nnoremap <leader>nd :LspDiag next \| LspDiag current<CR>
nnoremap <leader>pd :LspDiag prev \| LspDiag current<CR>
inoremap <silent> <C-Space> <C-x><C-o>

" Set omnifunc for completion
autocmd FileType php setlocal omnifunc=lsp#complete

autocmd User LspSetup call LspOptionsSet(#{
    \   diagSignErrorText: '✘',
    \   diagSignWarningText: '▲',
    \   diagSignInfoText: '»',
    \   diagSignHintText: '⚑',
    \ })
