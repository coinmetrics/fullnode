{ nixpkgs, version }:
rec {
  package = with nixpkgs; rustPlatform.buildRustPackage {
    pname = "polkadot";
    inherit version;

    cargoSha256 = {
      "0.8.30" = "1xcadx5vnnaygqksyh58qc2jjgpg7hfgi3149l64aaf72316vi84";
      "0.9.2"  = "0gg42b6h8782wny3dr9gc38wl6bybyf4smashchgrpc649ds6w0a";
      "0.9.3"  = "131fkdazcspblzblmd9nhkymwn7qh6lhaqvi1jqnsq4951l9f4ms";
      "0.9.5"  = "18pg09v14991aqq7cjg0w5x36526y6sx1hvxlqb20zvrgmv722cq";
      "0.9.6"  = "17c45xi1wr77jbkcl1mkxflc8f9hilil02c43fihvlh2lm8kcs5j";
      "0.9.7"  = "033dcv25kjniz7i3n072wrqam2g4krvnhd4svix27kz47pqz2y72";
    }.${version} or lib.fakeSha256;

    src = builtins.fetchGit {
      url = "https://github.com/paritytech/polkadot.git";
      ref = "refs/tags/v${version}";
    };

    nativeBuildInputs = [ llvmPackages_12.clang ];
    buildInputs = [ pkgconfig openssl ];
    LIBCLANG_PATH = "${llvmPackages_12.libclang.lib}/lib";
    PROTOC = "${protobuf}/bin/protoc";

    # building WASM binary is complicated
    # see https://github.com/NixOS/nixpkgs/pull/98785
    # and https://gitlab.w3f.tech/florian/w3fpkgs/-/blob/master/pkgs/parity-polkadot/default.nix
    SKIP_WASM_BUILD = 1;

    runVend = true;
    doCheck = false;
  };

  imageConfig = {
    config = {
      Entrypoint = [ "${package}/bin/polkadot" ];
      User = "1000:1000";
    };
  };
}
