" Vim One
 colorscheme one
  "Credit joshdick
  "Use 24-bit (true-color) mode in Vim/Neovim when outside tmux.
  "If you're using tmux version 2.2 or later, you can remove 
  "the outermost $TMUX check and use tmux's 24-bit color support
  "(see < http://sunaku.github.io/tmux-24bit-color.html#usage > for more information.)
  if (empty($TMUX))
    if (has("nvim"))
    "For Neovim 0.1.3 and 0.1.4 < https://github.com/neovim/neovim/pull/2198 >
      let $NVIM_TUI_ENABLE_TRUE_COLOR=1
    endif
    "For Neovim > 0.1.5 and Vim > patch 7.4.1799 
    "< https://github.com/vim/vim/commit/61be73bb0f965a895bfb064ea3e55476ac175162 >
    "Based on Vim patch 7.4.1770 (`guicolors` option) 
    "< https://github.com/vim/vim/commit/8a633e3427b47286869aa4b96f2bfc1fe65b25cd >
    "< https://github.com/neovim/neovim/wiki/Following-HEAD#20160511 >
    if (has("termguicolors"))
      set termguicolors
    endif
  endif
  set background=dark
  let g:airline_theme = 'one'

" Vim ToggleTerm.nvim

lua << EOF
  require("toggleterm").setup{
   -- size can be a number or function which is passed the current terminal
   size = 100,
   open_mapping = [[<c-\>]],
   hide_numbers = true, -- hide the number column in toggleterm buffers
   shade_filetypes = {},
   shade_terminals = true,
   shading_factor = '1.3', -- the degree by which to darken to terminal colour, default: 1 for dark backgrounds, 3 for light
   start_in_insert = true,
   insert_mappings = true, -- whether or not the open mapping applies in insert mode
   terminal_mappings = true, -- whether or not the open mapping applies in the opened terminals
   persist_size = false,
   direction = 'float',
   close_on_exit = true, -- close the terminal window when the process exits
   shell = vim.o.shell, -- change the default shell
    -- This field is only relevant if direction is set to 'float'
   float_opts = {
      -- The border key is *almost* the same as 'nvim_open_win'
      -- see :h nvim_open_win for details on borders however
      -- the 'curved' border is a custom border type
      -- not natively supported but implemented in this plugin.
      border = 'curved', 
      width = 100,
      height = 50,
      winblend = 3,
      highlights = {
        border = "Normal",
        background = "Normal",
      }
    }
  }
  function _G.set_terminal_keymaps()
    local opts = {noremap = true}
    vim.api.nvim_buf_set_keymap(0, 't', '<esc>', [[<C-\><C-n>]], opts)
    vim.api.nvim_buf_set_keymap(0, 't', 'jk', [[<C-\><C-n>]], opts)
    vim.api.nvim_buf_set_keymap(0, 't', '<C-h>', [[<C-\><C-n><C-W>h]], opts)
    vim.api.nvim_buf_set_keymap(0, 't', '<C-j>', [[<C-\><C-n><C-W>j]], opts)
    vim.api.nvim_buf_set_keymap(0, 't', '<C-k>', [[<C-\><C-n><C-W>k]], opts)
    vim.api.nvim_buf_set_keymap(0, 't', '<C-l>', [[<C-\><C-n><C-W>l]], opts)
  end
  -- if you only want these mappings for toggle term use term://*toggleterm#* instead
  vim.cmd('autocmd! TermOpen term://* lua set_terminal_keymaps()')
  local Terminal  = require('toggleterm.terminal').Terminal
  local lazygit = Terminal:new({
    cmd = "lazygit",
    dir = "git_dir",
    direction = "float",
    float_opts = {
      border = "double",
    }
  })
  function _lazygit_toggle()
    lazygit:toggle()
  end
  vim.api.nvim_set_keymap("n", "<leader>g", "<cmd>lua _lazygit_toggle()<CR>", {noremap = true, silent = true})

EOF

" NERDTree
"
" If another buffer tries to replace NERDTree, put it in the other window, and bring back NERDTree.
  autocmd BufEnter * if bufname('#') =~ 'NERD_tree_\d\+' && bufname('%') !~ 'NERD_tree_\d\+' && winnr('$') > 1 |
      \ let buf=bufnr() | buffer# | execute "normal! \<C-W>w" | execute 'buffer'.buf | endif
  
  " Denite
  " https://github.com/ctaylo21/jarvis/blob/master/config/nvim/init.vim#L58
  "
  try
  " === Denite setup ==="
  " Use ripgrep for searching current directory for files
  " By default, ripgrep will respect rules in .gitignore
  "   --files: Print each file that would be searched (but don't search)
  "   --glob:  Include or exclues files for searching that match the given glob
  "            (aka ignore .git files)
  "
  call denite#custom#var('file/rec', 'command', ['rg', '--files', '--glob', '!.git'])
  
  " Use ripgrep in place of "grep"
  call denite#custom#var('grep', 'command', ['rg'])
  
  " Custom options for ripgrep
  "   --vimgrep:  Show results with every match on it's own line
  "   --hidden:   Search hidden directories and files
  "   --heading:  Show the file name above clusters of matches from each file
  "   --S:        Search case insensitively if the pattern is all lowercase
  call denite#custom#var('grep', 'default_opts', ['--hidden', '--vimgrep', '--heading', '-S'])
  
  " Recommended defaults for ripgrep via Denite docs
  call denite#custom#var('grep', 'recursive_opts', [])
  call denite#custom#var('grep', 'pattern_opt', ['--regexp'])
  call denite#custom#var('grep', 'separator', ['--'])
  call denite#custom#var('grep', 'final_opts', [])
  
  " Remove date from buffer list
  call denite#custom#var('buffer', 'date_format', '')
  
  " Custom options for Denite
  "   split                       - Use floating window for Denite
  "   start_filter                - Start filtering on default
  "   auto_resize                 - Auto resize the Denite window height automatically.
  "   source_names                - Use short long names if multiple sources
  "   prompt                      - Customize denite prompt
  "   highlight_matched_char      - Matched characters highlight
  "   highlight_matched_range     - matched range highlight
  "   highlight_window_background - Change background group in floating window
  "   highlight_filter_background - Change background group in floating filter window
  "   winrow                      - Set Denite filter window to top
  "   vertical_preview            - Open the preview window vertically
  
  let s:denite_options = {'default' : {
  \ 'split': 'floating',
  \ 'start_filter': 1,
  \ 'auto_resize': 1,
  \ 'source_names': 'short',
  \ 'prompt': 'λ ',
  \ 'highlight_matched_char': 'QuickFixLine',
  \ 'highlight_matched_range': 'Visual',
  \ 'highlight_window_background': 'Visual',
  \ 'highlight_filter_background': 'DiffAdd',
  \ 'winrow': 1,
  \ 'vertical_preview': 1
  \ }}
  
  " Loop through denite options and enable them
  function! s:profile(opts) abort
    for l:fname in keys(a:opts)
      for l:dopt in keys(a:opts[l:fname])
        call denite#custom#option(l:fname, l:dopt, a:opts[l:fname][l:dopt])
      endfor
    endfor
  endfunction
  
  call s:profile(s:denite_options)
  catch
    echo 'Denite not installed. It should work after running :PlugInstall'
  endtry
    " === Denite shorcuts === "
  "   ;         - Browser currently open buffers
  "   <leader>t - Browse list of files in current directory
  "   <leader>g - Search current directory for occurences of given term and close window if no results
  "   <leader>j - Search current directory for occurences of word under cursor
  nmap ; :Denite buffer<CR>
  nmap <leader>t :DeniteProjectDir file/rec<CR>
  nnoremap <leader>g :<C-u>Denite grep:. -no-empty<CR>
  nnoremap <leader>j :<C-u>DeniteCursorWord grep:.<CR>

  " Define mappings while in 'filter' mode
  "   <C-o>         - Switch to normal mode inside of search results
  "   <Esc>         - Exit denite window in any mode
  "   <CR>          - Open currently selected file in any mode
  "   <C-t>         - Open currently selected file in a new tab
  "   <C-v>         - Open currently selected file a vertical split
  "   <C-h>         - Open currently selected file in a horizontal split
  autocmd FileType denite-filter call s:denite_filter_my_settings()
  function! s:denite_filter_my_settings() abort
    imap <silent><buffer> <C-o>
    \ <Plug>(denite_filter_update)
    inoremap <silent><buffer><expr> <Esc>
    \ denite#do_map('quit')
    nnoremap <silent><buffer><expr> <Esc>
    \ denite#do_map('quit')
    inoremap <silent><buffer><expr> <CR>
    \ denite#do_map('do_action')
    inoremap <silent><buffer><expr> <C-t>
    \ denite#do_map('do_action', 'tabopen')
    inoremap <silent><buffer><expr> <C-v>
    \ denite#do_map('do_action', 'vsplit')
    inoremap <silent><buffer><expr> <C-h>
    \ denite#do_map('do_action', 'split')
  endfunction
  
  " Define mappings while in denite window
  "   <CR>        - Opens currently selected file
  "   q or <Esc>  - Quit Denite window
  "   d           - Delete currenly selected file
  "   p           - Preview currently selected file
  "   <C-o> or i  - Switch to insert mode inside of filter prompt
  "   <C-t>       - Open currently selected file in a new tab
  "   <C-v>       - Open currently selected file a vertical split
  "   <C-h>       - Open currently selected file in a horizontal split
  autocmd FileType denite call s:denite_my_settings()
  function! s:denite_my_settings() abort
    nnoremap <silent><buffer><expr> <CR>
    \ denite#do_map('do_action')
    nnoremap <silent><buffer><expr> q
    \ denite#do_map('quit')
    nnoremap <silent><buffer><expr> <Esc>
    \ denite#do_map('quit')
    nnoremap <silent><buffer><expr> d
    \ denite#do_map('do_action', 'delete')
    nnoremap <silent><buffer><expr> p
    \ denite#do_map('do_action', 'preview')
    nnoremap <silent><buffer><expr> i
    \ denite#do_map('open_filter_buffer')
    nnoremap <silent><buffer><expr> <C-o>
    \ denite#do_map('open_filter_buffer')
    nnoremap <silent><buffer><expr> <C-t>
    \ denite#do_map('do_action', 'tabopen')
    nnoremap <silent><buffer><expr> <C-v>
    \ denite#do_map('do_action', 'vsplit')
    nnoremap <silent><buffer><expr> <C-h>
    \ denite#do_map('do_action', 'split')
  endfunction
  " === Coc.nvim === "
  " use <tab> for trigger completion and navigate to next complete item
  function! s:check_back_space() abort
    let col = col('.') - 1
    return !col || getline('.')[col - 1]  =~ '\s'
  endfunction
  
  inoremap <silent><expr> <TAB>
        \ pumvisible() ? "\<C-n>" :
        \ <SID>check_back_space() ? "\<TAB>" :
        \ coc#refresh()
  
  "Close preview window when completion is done.
  autocmd! CompleteDone * if pumvisible() == 0 | pclose | endif


" === NERDTree === "
  " Show hidden files/directories
  let g:NERDTreeShowHidden = 1
  
  " Remove bookmarks and help text from NERDTree
  let g:NERDTreeMinimalUI = 1
  
  " Custom icons for expandable/expanded directories
  let g:NERDTreeDirArrowExpandable = '⬏'
  let g:NERDTreeDirArrowCollapsible = '⬎'
  
  " Hide certain files and directories from NERDTree
  let g:NERDTreeIgnore = ['^\.DS_Store$', '^tags$', '\.git$[[dir]]', '\.idea$[[dir]]', '\.sass-cache$']
  " Open the existing NERDTree on each new tab.
  autocmd BufWinEnter * if getcmdwintype() == '' | silent NERDTreeMirror | endif
