
{ config, pkgs, ... }:

{

  # environment.systemPackages = [
  #   pkgs.dashy
  #   pkgs.nginx
  # ];
  #
  # services.nginx = {
  #   enable = true;
  #   virtualHosts.${config.services.dashy.virtualHost} = {
  #     listen = [{
  #       addr = "0.0.0.0";
  #       port = 8080;
  #     }];
  #   };
  # };

}
