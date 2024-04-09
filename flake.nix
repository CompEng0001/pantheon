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
          ./vakare/base.nix
          ./vakare/hardware.nix
          ./vakare/services.nix
          ./oculus/packages.nix
          ./oculus/vm.nix
          ./oculus/vim.nix
        ];
      };
      aitvaras = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./aitvaras/base.nix
          ./aitvaras/hardware.nix
          ./aitvaras/services.nix
          ./oculus/packages.nix
          ./oculus/vm.nix
          ./oculus/vim.nix
        ];
      };
      minerva = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./minerva/base.nix
          ./minerva/hardware.nix
          ./minerva/services.nix
          ./oculus/packages.nix
          ./oculus/vm.nix
          ./oculus/vim.nix
        ];
      };
    };
  };
}

