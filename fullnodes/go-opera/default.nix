{ pkgs, version }:
rec {
  package = pkgs.callPackage (./. + "/go-opera-${version}.nix") {};

  imageConfig = {
    config = {
      Entrypoint = [ "${package}/bin/opera" ];
      User = "1000:1000";
    };
  };
}
