{ inputs, pkgs, ... }: {

  environment.systemPackages = [
    # Reference the package explicitly out of the flake input
    inputs.nvim-kickstart-nix.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];

  programs.neovim = {
    enable = false; # Keep this false to prevent global wrapper collision
  };

  environment.variables.EDITOR = "nvim";
}
