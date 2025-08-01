{
  description = "Zcash";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";
    utils = {
      url = "path:../..";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, flake-utils, nixpkgs, utils }:
  flake-utils.lib.eachDefaultSystem (system:
  let
    pkgs = import nixpkgs { inherit system; };

    makeImageConfig = package: {
      config = {
        Entrypoint = [ "${package}/bin/zcashd" ];
        User = "1000:1000";
      };

      extraCommands = ''
        mkdir ./bin && \
        ln -s ${pkgs.dash}/bin/dash ./bin/sh && \
        ln -s ${pkgs.gawk}/bin/awk ./bin/awk && \
        ln -s ${package}/bin/zcashd ./bin/zcashd && \
        ln -s ${package}/bin/zcash-cli ./bin/zcash-cli
      '';
    };

    generatedFlake = with pkgs; utils.lib.${system}.makeFlake {
      inherit makeImageConfig;
      name = "zcash";
      version = "6.3.0";
      vars = {
        inherit (darwin.apple_sdk.frameworks) Security;
        boost = boost183;
        db = db62;
        llvmPackages = llvmPackages_15;
      };
    };
  in {
    packages = generatedFlake.packages;
    apps = generatedFlake.apps // utils.lib.${system}.loginApp;
  });
}
