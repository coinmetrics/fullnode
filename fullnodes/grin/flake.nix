{
  description = "Grin";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";
    utils.url = "path:../..";
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
        Entrypoint = [ "${package}/bin/grin" ];
        User = "1000:1000";
      };
    };

generatedFlake = utils.lib.${system}.makeFlake {
  inherit makeImageConfig;
  name = "grin";
  version = "5.4.0";
  vars = {
    rust-bin = pkgs.rust-bin;
    makeRustPlatform = pkgs.makeRustPlatform;
  };
};
  in {
    packages = generatedFlake.packages;
    apps = generatedFlake.apps // utils.lib.${system}.loginApp;
  });
}