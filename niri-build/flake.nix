{
  description = "NixOS configuration with Noctalia + Niri";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    noctalia-qs = {
      url = "github:noctalia-dev/noctalia-qs";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs";
      # IMPORTANT: this name must match what noctalia-shell expects (noctalia-qs)
      inputs.noctalia-qs.follows = "noctalia-qs";
    };
  };

  outputs = inputs@{ self, nixpkgs, ... }: {
    nixosConfigurations.awesomebox = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux"; # <- don’t omit this
      specialArgs = { inherit inputs; };

      modules = [
        ./hardware-configuration.nix
        ./configuration.nix
	../nexus/modules/packages.nix
        ./noctalia.nix
      ];
    };
  };
}
