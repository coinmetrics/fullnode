{ pkgs, version }:
rec {
  package = pkgs.callPackage (./. + "/omnicore-${version}.nix") {};

  imageConfig = {
    config = {
      Entrypoint = [ "${package}/bin/omnicored" ];
      User = "1000:1000";
    };
  };
}
