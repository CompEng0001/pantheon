{ config, pkgs, ... }:
with import <nixpkgs> { };
with builtins;
with lib;
let
  home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/master.tar.gz";
in
{
  imports = [
    (import "${home-manager}/nixos")
  ];

  home-manager.users.seb = {
    /* Here goes your home-manager config, eg home.packages = [ pkgs.foo ]; */
    programs.home-manager.enable = true;
    programs.git = {
      enable = true;
      userName = "CompEng0001";
      userEmail = "sb1501@canterbury.ac.uk";
    };
  };
}
