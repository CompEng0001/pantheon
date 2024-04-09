{ config, lib, pkgs, ... }:

{
  programs.vscode = {
    enable = true;
    package = pkgs.vscode;
    extensions = with pkgs.vscode-extensions; [
      bbenoist.Nix
      marp-team.marp-vscode
      yzhang.markdown-all-in-one
      cweijan.vscode-database-client2
      ms-vscode.cpptools
      oderwat.indent-rainbow
    ];
    userSettings = {
      "terminal.integrated.fontFamily" = "Hack";
    };
  };
}
