{ pkgs, version }:
rec {
  package = pkgs.callPackage (./. + "/op-node-${version}.nix") {};

  imageConfig = {
    config = {
      Entrypoint = [ "${package}/bin/op-node" ];
      User = "1000:1000";
    };
  };
}
