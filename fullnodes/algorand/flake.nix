{
  description = "Algorand";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";
    utils.url = "path:../..";
  };

  outputs = { self, flake-utils, nixpkgs, utils }:
  flake-utils.lib.eachDefaultSystem (system:
  let
    pkgs = import nixpkgs { inherit system; };

    dataDir = "/var/lib/algorand";

    makeImageConfig = package:
    let
      entrypoint = pkgs.writeShellApplication {
        name = "algorand-entrypoint";
        runtimeInputs = [ pkgs.coreutils ];
        text = ''
          cd "$ALGORAND_DATA"

          if [ -f "/etc/algorand/config.json" ]; then
            cp /etc/algorand/config.json config.json
          fi

          if [ -f "/etc/algorand/logging.config" ]; then
            cp /etc/algorand/logging.config logging.config
          fi

          if [ -f "/etc/algorand-secrets/algod.token" ]; then
            cp /etc/algorand-secrets/algod.token algod.token
          fi

          if [ -f "/etc/algorand-secrets/algod.admin.token" ]; then
            cp /etc/algorand-secrets/algod.admin.token algod.admin.token
          fi

          ${package}/bin/algod -g "$ALGORAND_GENESIS/$ALGORAND_NETWORK/genesis.json" "$@"
        '';
      };
    in {
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
        mkdir -p ./etc/algorand-secrets

        echo "root:x:0:0:root:/root:" > ./etc/passwd
        echo "root:x:0:" > ./etc/group

        echo "algorand:x:1000:1000:algorand:${dataDir}:" >> ./etc/passwd
        echo "algorand:x:1000:" >> ./etc/group
      '';
    };

    generatedFlake = utils.lib.${system}.makeFlake {
      inherit makeImageConfig;
      name = "algorand";
      version = "4.1.1";
      vars = {
        buildGoModule = pkgs.buildGo123Module;
      };
    };
  in {
    packages = generatedFlake.packages;
    apps = generatedFlake.apps // utils.lib.${system}.loginApp;
  });
}
