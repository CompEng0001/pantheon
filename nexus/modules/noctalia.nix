{ config, pkgs, inputs, ... }:

let
  system = pkgs.stdenv.hostPlatform.system;
  noctaliaPkg = inputs.noctalia.packages.${system}.default;
in
{
  environment.systemPackages = [ noctaliaPkg ];

  systemd.user.services.noctalia = {
    description = "Noctalia shell";
    wantedBy = [ "graphical-session.target" ];
    after = [ "graphical-session.target" ];

    serviceConfig = {
      ExecStart = "${noctaliaPkg}/bin/noctalia-shell";
      Restart = "on-failure";
      RestartSec = 1;
    };
  };
}

