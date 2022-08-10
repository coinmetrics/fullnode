{ pkgs, version }:
rec {
  package = pkgs.callPackage (./. + "/lighthouse-${version}.nix") { };

  imageConfig = {
    config = {
      Entrypoint = [ "${package}/bin/lighthouse" ];
      User = "1000:1000";
    };
  };
}
