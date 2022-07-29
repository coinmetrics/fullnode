{ pkgs, version }:
rec {
  package = pkgs.callPackage (./. + "/zcash-${version}.nix") {
    stdenv = pkgs.llvmPackages_13.stdenv;
  };

  imageConfig = {
    config = {
      Entrypoint = [ "${package}/bin/zcashd" ];
      User = "1000:1000";
    };

    extraCommands = ''
      mkdir ./bin && \
      ln -s ${pkgs.dash}/bin/dash ./bin/sh && \
      ln -s ${pkgs.gawk}/bin/awk ./bin/awk && \
      ln -s ${package}/bin/zcashd ./bin/zcashd && \
      ln -s ${package}/bin/zcash-cli ./bin/zcash-cli
    '';
  };
}
