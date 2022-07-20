{ pkgs, version }:
rec {
  package = pkgs.callPackage (./. + "/vertcoin-${version}.nix") {};

  imageConfig = {
    config = {
      Entrypoint = [ "${package}/bin/vertcoind" ];
      User = "1000:1000";
    };
  };
}
