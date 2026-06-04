{
  description = "Zcash";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";
    utils = {
      url = "path:../..";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    rust-overlay.url = "github:oxalica/rust-overlay";
  };

  outputs = { self, flake-utils, nixpkgs, utils, rust-overlay }:
  flake-utils.lib.eachDefaultSystem (system:
  let
    pkgs = import nixpkgs {
      inherit system;
      overlays = [ rust-overlay.overlays.default ];
    };

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
      version = "6.20.0";
      vars = {
        boost = boost183;
        db = db62;
        llvmPackages = llvmPackages_21;
        rust-bin = pkgs.rust-bin;
        makeRustPlatform = pkgs.makeRustPlatform;
      };
    };
  in {
    packages = generatedFlake.packages;
    apps = generatedFlake.apps // utils.lib.${system}.loginApp;
  });
}
