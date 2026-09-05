{ pkgs }:

let
  runtimeDeps = with pkgs; [
    # Used by the Lua configuration.
    git
    ripgrep

    # Required by minimap-vim.
    code-minimap

    # Language servers.
    bash-language-server
    clang-tools
    ltex-ls-plus
    lua-language-server
    nixd
    rust-analyzer

    # Linters / formatters.
    shellcheck
    stylua
    prettier
  ];
in
pkgs.wrapNeovimUnstable pkgs.neovim-unwrapped {
  # Keep the normal ~/.config/nvim/init.lua entry point. Nix only supplies
  # Neovim, plugins, and external executables.
  wrapRc = false;

  vimAlias = true;
  viAlias = true;

  withPython3 = false;
  withNodeJs = false;
  withPerl = false;
  withRuby = false;

  plugins = with pkgs.vimPlugins; [
    # Editing.
    delimitMate
    vim-sleuth
    vim-better-whitespace
    tabular

    # UI / navigation.
    indentLine
    minimap-vim
    vim-illuminate

    # Git.
    vim-signify

    # Writing.
    goyo-vim
    limelight-vim
    vimtex

    # Colours in source files.
    vim-hexokinase

    # Extra filetype support from the old Vim configuration.
    i3config-vim
    swayconfig-vim
  ];

  # Make LSP servers, formatters, rg, git, etc. available only in the wrapped
  # Neovim environment without requiring them in the global system PATH.
  wrapperArgs = [
    "--prefix"
    "PATH"
    ":"
    (pkgs.lib.makeBinPath runtimeDeps)
  ];
}
