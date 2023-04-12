{ pkgs, version }:
rec {
  package = pkgs.callPackage (./. + "/algorand-indexer-${version}.nix") {};
  dataDir = "/var/lib/algorand-indexer";

  entrypoint = pkgs.writeShellApplication {
    name = "algorand-indexer-entrypoint";
    runtimeInputs = [ pkgs.coreutils ];
    text = ''
      ${package}/bin/algorand-indexer daemon --genesis "$ALGORAND_GENESIS/$ALGORAND_NETWORK/genesis.json" "$@"
    '';
  };
  imageConfig = {
    config = {
      Entrypoint = [ "${entrypoint}/bin/algorand-indexer-entrypoint" ];

      Env = [
        "INDEXER_DATA=${dataDir}"
        "ALGORAND_GENESIS=${package.genesis}"
        "ALGORAND_NETWORK=mainnet"
      ];

      User = "1000:1000";
    };
  };
}
