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
    vimAlias = false;
    vimdiffAlias = true;

    extraLuaConfig = ''
      require('main.lua') 
    '';
  };

  xdg = {
    enable = true;
    # kickstart
    configFile."nvim-kickstart" = {
      source = "${inputs.nvim-kickstart}";
      recursive = true;
    };
    # neovim
    configFile."nvim/lua" = {
      source = ../conf.d/nvim/lua;
      recursive = true;
    };
  };

  programs.git.settings.merge.tool = "nvimdiff";

  home = {
    packages = with pkgs; [
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
  };
}
