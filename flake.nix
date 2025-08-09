# /home/dev/Git/personal/pantheon/flake.nix
{
  description = "NixOS configuration for multiple machines";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }: {
    nixosConfigurations = {
      scirocco = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/scirocco
          ./hardware/scirocco
          ./services/scirocco
          ./nexus/modules
        ];
      };
      aitvaras = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/aitvaras
          ./hardware/aitvaras
          ./nexus/modules
          ./services
        ];
      };
      minerva = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/minerva
          ./hardware/minerva
          ./nexus/modules
          ./services
        ];
      };
    };
  };
}

