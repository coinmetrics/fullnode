{ pkgs, version }:
rec {
  package = pkgs.callPackage (./. + "/erigon-${version}.nix") {
    boost = pkgs.boost181;
    llvmPackages = pkgs.llvmPackages_17;
  };

  imageConfig = {
    config = {
      Entrypoint = [ "${package}/bin/erigon" ];
      User = "1000:1000";
    };
  };
}
