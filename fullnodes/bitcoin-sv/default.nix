{ nixpkgs, version }:
rec {
  package = nixpkgs.callPackage (./. + "/bitcoin-sv-${version}.nix") {};

  imageConfig = {
    config = {
      Entrypoint = [ "${package}/bin/bitcoind" ];
      User = "1000:1000";
    };

    extraCommands = ''
      mkdir ./bin && \
      ln -s ${package}/bin/bitcoind ./bin/bitcoind
    '';
  };
}
