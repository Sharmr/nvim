" ################################################################################
" Plugins
" ################################################################################

" Vim Airline
  Plug 'vim-airline/vim-airline'

" Vim One
  Plug 'rakr/vim-one'
 
"ToggleTerm.nvim 
  Plug 'akinsho/toggleterm.nvim'

" NERDTree
  Plug 'preservim/nerdtree'
  Plug 'ryanoasis/vim-devicons'

" Denite
  if has('nvim')
    Plug 'Shougo/denite.nvim', { 'do': ':UpdateRemotePlugins' }
  else
    Plug 'Shougo/denite.nvim'
    Plug 'roxma/nvim-yarp'
    Plug 'roxma/vim-hug-neovim-rpc'
  endif

  " Coc.nvim
  
  Plug 'neoclide/coc.nvim', {'branch': 'master', 'do': 'yarn install --frozen-lockfile'}
  Plug 'neoclide/coc-tsserver', {'branch': 'master', 'do': 'yarn install --frozen-lockfile'}

