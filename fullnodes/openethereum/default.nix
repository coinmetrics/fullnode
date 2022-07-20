{ pkgs, version }:
rec {
  package = pkgs.callPackage (./. + "/openethereum-${version}.nix") {
    stdenv = pkgs.llvmPackages_12.stdenv;
  };

  imageConfig = {
    config = {
      Entrypoint = [ "${package}/bin/openethereum" ];
      User = "1000:1000";
    };

    extraCommands = ''
      mkdir ./bin && \
      ln -s ${pkgs.dash}/bin/dash ./bin/sh && \
      ln -s ${pkgs.gawk}/bin/awk ./bin/awk && \
      ln -s ${package}/bin/openethereum ./bin/openethereum
    '';
  };
}
