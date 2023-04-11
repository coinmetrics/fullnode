{ pkgs, version }:
rec {
  package = pkgs.callPackage (./. + "/algorand-${version}.nix") {};
  dataDir = "/var/lib/algorand";

  entrypoint = pkgs.writeShellApplication {
    name = "algorand-entrypoint";
    runtimeInputs = [ pkgs.coreutils ];
    text = ''
      cd "$ALGORAND_DATA"

      if [ -f "/etc/algorand/config.json" ]; then
        cp /etc/algorand/config.json config.json
      fi
      if [ -f "/etc/algorand/algod.token" ]; then
        cp /etc/algorand/algod.token algod.token
      fi
      if [ -f "/etc/algorand/algod.admin.token" ]; then
        cp /etc/algorand/algod.admin.token algod.admin.token
      fi
      if [ -f "/etc/algorand/logging.config" ]; then
        cp /etc/algorand/logging.config logging.config
      fi

      ${package}/bin/algod -g "$ALGORAND_GENESIS/$ALGORAND_NETWORK/genesis.json" "$@"
    '';
  };

  imageConfig = {
    config = {
      Entrypoint = [ "${entrypoint}/bin/algorand-entrypoint" ];

      Env = [
        "ALGORAND_DATA=${dataDir}"
        "ALGORAND_GENESIS=${package.genesis}"
        "ALGORAND_NETWORK=mainnet"
      ];

      User = "1000:1000";
    };

    fakeRootCommands = ''
      mkdir -p ./${dataDir}
      chown 1000:1000 ./${dataDir}

      mkdir -p ./etc/algorand
      echo "root:x:0:0:root:/root:" > ./etc/passwd
      echo "root:x:0:" > ./etc/group

      echo "algorand:x:1000:1000:algorand:${dataDir}:" >> ./etc/passwd
      echo "algorand:x:1000:" >> ./etc/group
    '';
  };
}
