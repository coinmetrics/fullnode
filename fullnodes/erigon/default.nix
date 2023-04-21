{ pkgs, version }:
rec {
  package = pkgs.callPackage (./. + "/erigon-${version}.nix") {};

  imageConfig = {
    config = {
      Entrypoint = [ "${package}/bin/erigon" ];
      User = "1000:1000";
    };
  };
}
