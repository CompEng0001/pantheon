{ ... }:

{
  nixpkgs.overlays = [
    (final: prev: {
      displaylink = prev.displaylink.override {
        requireFile =
          { name, hash, ... }:
          final.fetchurl {
            inherit name hash;

            url =
              "https://www.synaptics.com/sites/default/files/exe_files/"
              + "2025-09/"
              + "DisplayLink%20USB%20Graphics%20Software%20for%20Ubuntu6.2-EXE.zip";
          };
      };
    })
  ];

  services.xserver.videoDrivers = [
    "modesetting"
    "displaylink"
  ];
}
