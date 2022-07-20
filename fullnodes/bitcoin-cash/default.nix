{ pkgs, version }:
rec {
  package = pkgs.callPackage (./. + "/bitcoin-cash-${version}.nix") {};

  imageConfig = {
    config = {
      Entrypoint = [ "${package}/bin/bitcoind" ];
      User = "1000:1000";
    };

    extraCommands = ''
      mkdir ./bin && \
      ln -s ${package}/bin/bitcoind ./bin/bitcoind && \
      ln -s ${package}/bin/bitcoin-cli ./bin/bitcoin-cli && \
      ln -s ${package}/bin/bitcoin-seeder ./bin/bitcoin-seeder && \
      ln -s ${package}/bin/bitcoin-tx ./bin/bitcoin-tx
    '';
  };
}
