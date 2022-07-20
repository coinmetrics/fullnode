{ pkgs, version }:
rec {
  package = pkgs.callPackage (./. + "/elements-${version}.nix") {};

  imageConfig = {
    config = {
      Entrypoint = [ "${package}/bin/elementsd" ];
      User = "1000:1000";
    };
  };
}
