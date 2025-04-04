{
  description = "Bitcoin Cash";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";
    utils.url = "path:../..";
  };

  outputs = { self, flake-utils, nixpkgs, utils }:
  flake-utils.lib.eachDefaultSystem (system:
  let
    pkgs = import nixpkgs { inherit system; };

    makeImageConfig = package: {
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

    generatedFlake = utils.lib.${system}.makeFlake {
      inherit makeImageConfig;
      name = "bitcoin-cash";
      version = "28.0.1";
    };
  in {
    packages = generatedFlake.packages;
    apps = generatedFlake.apps // utils.lib.${system}.loginApp;
  });
}
