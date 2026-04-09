{ config, pkgs, inputs, ... }:

{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };


  xdg = {
    enable = true;
    # neovim
    configFile."nvim-kickstart" = {
      source = "${inputs.nvim-kickstart}";
      recursive = true;
    };
  };

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
