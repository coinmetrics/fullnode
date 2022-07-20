{ pkgs, version }:
rec {
  package = pkgs.callPackage (./. + "/grin-${version}.nix") {};

  imageConfig = {
    config = {
      Entrypoint = [ "${package}/bin/grin" ];
      User = "1000:1000";
    };
  };
}
