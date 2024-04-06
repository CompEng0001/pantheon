# /etc/nixos/flake.nix
{
  description = "flake for vakare";

  inputs = {
    nixpkgs = {
      url = "github:NixOS/nixpkgs/nixos-unstable";
    };
  };

  outputs = { self, nixpkgs }: {
    nixosConfigurations = {
      vakare = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          /home/seb/Git/personal/pantheon/vakare/nixos/hardware-configuration.nix
          /home/seb/Git/personal/pantheon/vakare/nixos/base.nix
          /home/seb/Git/personal/pantheon/vakare/nixos/services.nix
          /home/seb/Git/personal/pantheon/oculus/packagees.nix
          /home/seb/Git/personal/pantheon/oculus/rstudio.nix
          /home/seb/Git/personal/pantheon/oculus/vim.nix
          /home/seb/Git/personal/pantheon/oculus/vm.nix
        ];
      };
    };
  };
}
