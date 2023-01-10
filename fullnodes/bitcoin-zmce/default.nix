{ pkgs, version }:
rec {
  package = with pkgs; callPackage (./. + "/bitcoin-zmce-${version}.nix") {
    boost = boost17x;
    miniupnpc = miniupnpc;
    withGui = false;
    withWallet = false;
    inherit (darwin) autoSignDarwinBinariesHook;
  };

  imageConfig = {
    config = {
      Entrypoint = [ "${package}/bin/bitcoind" ];
      User = "1000:1000";
    };

    extraCommands = ''
      mkdir ./bin && \
      ln -s ${package}/bin/bitcoind ./bin/bitcoind && \
      ln -s ${package}/bin/bitcoin-cli ./bin/bitcoin-cli
    '';
  };
}
