# nexus/modules/hyprfm.nix

{ pkgs, ... }:

let
  hyprfmFlake = builtins.getFlake
    "github:soyeb-jim285/hyprfm/a662678ce7a18c260dc95bac4b8e3cdf877f8175";
in
{
  nixpkgs.overlays = [
    (final: prev: {
      hyprfm =
        hyprfmFlake.packages.${final.stdenv.hostPlatform.system}.hyprfm;
    })
  ];

  services.gvfs.enable = true;
}
