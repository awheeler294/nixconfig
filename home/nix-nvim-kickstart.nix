{ ... }:

{
  programs.git.settings.merge.tool = "nvimdiff";

  home.shellAliases = {
    vin = "nvim";
    nv = "nvim --clean";
  };
}
