{ config, pkgs, inputs, lib, ... }:

{
   
  environment.systemPackages = with pkgs; [
    cargo
    rustc
    rustup
  ];
}
