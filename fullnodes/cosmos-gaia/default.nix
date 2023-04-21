{ pkgs, version }:
rec {
  package = pkgs.callPackage (./. + "/cosmos-gaia-${version}.nix") {};

  imageConfig = {
    config = {
      Entrypoint = [ "${package}/bin/gaiad" ];
      User = "1000:1000";
    };
  };
}
