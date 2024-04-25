{ pkgs, version }:
rec {
  package = pkgs.callPackage (./. + "/op-geth-${version}.nix") {};

  imageConfig = {
    config = {
      Entrypoint = [ "${package}/bin/geth" ];
      User = "1000:1000";
    };
  };
}
