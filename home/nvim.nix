{
  config,
  pkgs,
  inputs,
  ...
}:

{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    package = pkgs.neovim-unwrapped;
    vimAlias = false;
    vimdiffAlias = true;

    extraLuaConfig = ''
      require('main.lua') 
    '';

    extraPackages = with pkgs; [
      autotools-language-server
      awk-language-server
      bash-language-server
      cmake-language-server
      docker-language-server
      haskell-language-server
      java-language-server
      jq-lsp
      kotlin-language-server
      lua-language-server
      markdownlint-cli
      nginx-language-server
      systemd-language-server
      tree-sitter
      typescript-language-server
      vim-language-server
      yaml-language-server
    ];

    plugins = with pkgs.vimPlugins; [
      # ASCII diagram editor
      venn-nvim

      # Themes
      gruvbox-nvim

      # mini-icons

      # Languages, etc.
      direnv-vim
      ghcid
      catppuccin-nvim
      nvim-web-devicons

      # Usage
      # https://nixos.org/manual/nixpkgs/unstable/#vim
      #
      # Available parsers
      # https://tree-sitter.github.io/tree-sitter/#available-parsers
      (nvim-treesitter.withPlugins (
        plugins: with plugins; [
          tree-sitter-nix

          # This one is too slow for my taste. :(
          # But I don't have anything else. Not a fan of `vim-elixir`.
          tree-sitter-elixir

          # Web front-end stuff
          tree-sitter-typescript
          tree-sitter-javascript
          tree-sitter-html
          tree-sitter-css
          tree-sitter-sql

          tree-sitter-rust
          tree-sitter-haskell
          tree-sitter-lua

          # Shell
          tree-sitter-fish
          tree-sitter-bash

          tree-sitter-make
        ]
      ))

      todo-comments-nvim
      # fidget-nvim

      # I don't know how to categorize this
      # plenary-nvim

      # telescope-nvim
      # telescope-ui-select-nvim
      # null-ls-nvim

      # nvim-web-devicons
      auto-pairs
      # nvim-fzf
      # trouble-nvim
      vim-commentary
      vim-surround
      # which-key-nvim

      # Magit is unfortunately still king :(
      # gitsigns-nvim
     ];
  };

  xdg = {
    enable = true;
    # kickstart
    configFile."nvim" = {
      source = "${inputs.nvim-kickstart}";
      recursive = true;
    };
  };

  programs.git.settings.merge.tool = "nvimdiff";

  # home = {
  #   packages = with pkgs; [
  #     autotools-language-server
  #     awk-language-server
  #     bash-language-server
  #     cmake-language-server
  #     docker-language-server
  #     haskell-language-server
  #     java-language-server
  #     jq-lsp
  #     kotlin-language-server
  #     lua-language-server
  #     markdownlint-cli
  #     nginx-language-server
  #     systemd-language-server
  #     tree-sitter
  #     typescript-language-server
  #     vim-language-server
  #     yaml-language-server
  #   ];
  # };
}
