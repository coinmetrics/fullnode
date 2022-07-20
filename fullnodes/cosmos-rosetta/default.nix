{ pkgs, version }:
rec {
  package = pkgs.callPackage (./. + "/cosmos-rosetta-${version}.nix") {};

  imageConfig = {
    config = {
      Entrypoint = [ "${package}/bin/crg" ];
      User = "1000:1000";
    };
  };
}
