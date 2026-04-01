{
  description = "NixOS configuration with Noctalia + Niri";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

  };

  outputs = inputs@{ self, nixpkgs, ... }: {
    nixosConfigurations.awesomebox = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux"; # <- don’t omit this
      specialArgs = { inherit inputs; };

      modules = [
        ./hardware-configuration.nix
        ./configuration.nix
	../nexus/modules/packages.nix
      ];
    };
  };
}
