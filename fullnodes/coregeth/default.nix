{ pkgs, version }:
rec {
  package = pkgs.callPackage (./. + "/coregeth-${version}.nix") {};

  imageConfig = {
    config = {
      Entrypoint = [ "${package}/bin/geth" ];
      User = "1000:1000";
    };
  };
}
