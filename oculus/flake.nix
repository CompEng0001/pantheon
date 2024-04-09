# /etc/nixos/flake.nix
{
  description = "Flake for vakare";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    pantheon.url = "path:/home/seb/Git/personal/pantheon";
  };

  outputs = { self, nixpkgs, pantheon }: {
    nixosConfigurations = {
      vakare = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          pantheon.default.nixos.base
          pantheon.default.nixos.hardware-configuration
          pantheon.default.nixos.services
          pantheon.oculus.vim
          pantheon.oculus.packages
          pantheon.oculus.vm
        ];
      };
      aitvaras = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          pantheon.default.nixos.base
          pantheon.default.nixos.hardware-configuration
          pantheon.default.nixos.services
          pantheon.oculus.vim
          pantheon.oculus.packages
          pantheon.oculus.vm
        ];
      };
      minerva = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          pantheon.default.nixos.base
          pantheon.default.nixos.hardware-configuration
          pantheon.default.nixos.services
          pantheon.oculus.vim
          pantheon.oculus.packages
          pantheon.oculus.vm
        ];
      };
    };
  };
}

