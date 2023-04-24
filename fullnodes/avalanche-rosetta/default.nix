{ pkgs, version }:
rec {
  package = pkgs.callPackage (./. + "/avalanche-rosetta-${version}.nix") {};

  imageConfig = {
    config = {
      Entrypoint = [ "${package}/bin/avalanche-rosetta" ];
      User = "1000:1000";
    };
  };
}
