{ nixpkgs, version }:
rec {
  package = nixpkgs.callPackage (./. + "/openethereum-${version}.nix") {
    stdenv = nixpkgs.llvmPackages_12.stdenv;
  };

  imageConfig = {
    config = {
      Entrypoint = [ "${package}/bin/openethereum" ];
      User = "1000:1000";
    };

    extraCommands = ''
      mkdir ./bin && \
      ln -s ${nixpkgs.dash}/bin/dash ./bin/sh && \
      ln -s ${nixpkgs.gawk}/bin/awk ./bin/awk && \
      ln -s ${package}/bin/openethereum ./bin/openethereum
    '';
  };
}
