{ pkgs, version }:
rec {
  package = pkgs.callPackage (./. + "/algorand-${version}.nix") {};

  imageConfig = {
    config = {
      Entrypoint = [ "${package}/bin/algorand" ];
      User = "1000:1000";
    };
  };
}
