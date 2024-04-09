# /home/seb/Git/personal/pantheon/flake.nix
{
  description = "NixOS configuration for multiple machines";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }: {
    nixosConfigurations = {
      vakare = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/vakare
          ./hardware/vakare
          ./nexus/modules
          ./services
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

