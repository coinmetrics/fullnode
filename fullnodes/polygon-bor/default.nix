{ pkgs, version }:
rec {
  package = pkgs.callPackage (./. + "/polygon-bor-${version}.nix") {};

  imageConfig = {
    config = {
      Entrypoint = [ "${package}/bin/bor" ];
      User = "1000:1000";
    };
  };
}
