{
  description = "Bitcoin ZMCE";

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
        ln -s ${package}/bin/bitcoin-cli ./bin/bitcoin-cli
      '';
    };

    generatedFlake = with pkgs; utils.lib.${system}.makeFlake {
      inherit makeImageConfig;
      name = "bitcoin-zmce";
      version = "28.1";
      vars = {
        boost = boost181;
        miniupnpc = miniupnpc;
        withGui = false;
        withWallet = false;
        inherit (darwin) autoSignDarwinBinariesHook;
      };
    };
  in {
    packages = generatedFlake.packages;
    apps = generatedFlake.apps // utils.lib.${system}.loginApp;
  });
}
