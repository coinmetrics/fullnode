{ pkgs, version }:
rec {
  package = pkgs.callPackage (./. + "/algorand-indexer-${version}.nix") {};

  imageConfig = {
    config = {
      Entrypoint = [ "${package}/bin/algorand-indexer" ];
      User = "1000:1000";
    };
  };
}
