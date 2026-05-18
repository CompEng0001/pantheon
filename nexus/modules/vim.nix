{ pkgs }:

pkgs.vim-full.overrideAttrs (drv: {
  vimrc = pkgs.vimUtils.vimrcFile {
    packages.myplugins = with pkgs.vimPlugins; {
      start = [
        ale                         # Asybchronous Lint Engine
        awesome-vim-colorschemes    # ColourSchemes
        delimitMate                 # automatic closing of quotes, parenthesis, brackets
        goyo-vim                    # Distraction-free writing in Vim.
        i3config-vim
        indentLine                  # used for displaying thin vertical lines at each indentation level for code indented with spaces
        lightline-vim               # provides multiple colorschemes to meet your editor colorscheme.
        limelight-vim               # visual range, hightlights where you are.
        minimap-vim                 # show minimap of file
        vim-sleuth                  # automatically adjusts 'shiftwidth' and 'expandtab' heuristically based on the current file
        rust-vim                    # rust analyser
        swayconfig-vim
        tabular                     # improve the readability of your code by lining up the elements on neighbouring lines
        #vim-clap
        vim-illuminate
        vim-better-whitespace
        vim-lastplace
        vim-nix
        vim-mucomplete
        rustaceanvim
        vim-signify
        vim-toml
        vim-hexokinase
        vim-shellcheck
        vim-markdown
      ];
      opt = [ vimtex ];
    };
    customRC = ''
      set nocompatible
      set showcmd
      set showmatch
      set ignorecase
      set smartcase
      set incsearch
      set modeline
      set smarttab
      set expandtab
      set smartindent
      set ruler
      set tabstop=4
      set softtabstop=4
      set shiftwidth=4
      set background=dark
      set history=500
      set backspace=indent,eol,start
      set nu
      set cursorline
      set laststatus=2
      set conceallevel=0
      set signcolumn=number
      set timeout timeoutlen=5000 ttimeoutlen=100
      if exists('+termguicolors')
        let &t_8f="\<Esc>[38;2;%lu;%lu;%lum"
        let &t_8b="\<Esc>[48;2;%lu;%lu;%lum"
        set termguicolors
      endif

      filetype plugin indent on
      colorscheme tender

      " mucomplete Settings
      set completeopt+=menuone
      set completeopt+=noinsert
      set shortmess+=c
      set belloff+=ctrlg

      " signify Settings
      set updatetime=100

      " indentLine Settings
      let g:indentLine_char_list = ['|', '¦', '┆', '┊']
      let g:indentLine_setColors = 1
      let g:indentLine_fileTypeExclude = ['help', 'main', 'vimfiler', 'json']
      let g:better_whitespace_filetypes_blacklist = ['diff', 'gitcommit',
      \ 'help', 'markdown', 'leaderGuide']

      " goyo Settings
      autocmd! User GoyoEnter Limelight
      autocmd! User GoyoLeave Limelight!

      " lightline Settings
      let g:lightline = {'colorscheme': 'deus'}
      set noshowmode

      " vimtex Settings
      let g:tex_flavor = 'latex'

      " hexokinase Settings
      let g:Hexokinase_highlighters = ['backgroundfull']
      let g:Hexokinase_refreshEvents =
        \ ['TextChanged', 'TextChangedI', 'InsertLeave', 'BufRead']

      " Autoload
      autocmd FileType tex :packadd vimtex

      " Show full message for diagnostic under cursor
      nnoremap <silent> <leader>m :ALEDetail<CR>

      " Optional message formatting
      let g:ale_echo_msg_format = '[%linter%] %s [%severity%]'

      " Start minimap automatically
      let g:minimap_auto_start = 1
      let g:minimap_auto_start_win_enter = 1

      " Open folds automatically
      set foldopen=all

      " limelight.vim
      let g:limelight_default_coefficient = 0.7
      augroup limelight_start
        autocmd!
        autocmd VimEnter * Limelight 0.7
      augroup END
    '';
  };

  postInstall = (drv.postInstall or "") + ''
    ln -sf "$vimrc" "$out/share/vim/vimrc"
  '';
})
