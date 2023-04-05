{ pkgs, version }:
rec {
  package = pkgs.callPackage (./. + "/algorand-${version}.nix") {};
  dataDir = "/var/lib/algorand";

  entrypoint = pkgs.writeShellApplication {
    name = "algorand-entrypoint";
    runtimeInputs = [ pkgs.coreutils ];
    text = ''
      [ -f "$ALGORAND_DATA/genesis.json" ] && rm "$ALGORAND_DATA/genesis.json"
      [ -f "$ALGORAND_DATA/config.json" ] && rm "$ALGORAND_DATA/config.json"

      ln -s ${package.config}/genesis/mainnet/genesis.json "$ALGORAND_DATA/genesis.json"
      ln -s ${package.config}/config.json "$ALGORAND_DATA/config.json"

      ${package}/bin/algod "$@"
    '';
  };

  imageConfig = {
    config = {
      Entrypoint = [ "${entrypoint}/bin/algorand-entrypoint" ];
      Env = [
        "ALGORAND_DATA=${dataDir}"
      ];

      User = "1000:1000";
    };

    fakeRootCommands = ''
      mkdir -p ./${dataDir}
      chown 1000:1000 ./${dataDir}
    '';
  };
}
