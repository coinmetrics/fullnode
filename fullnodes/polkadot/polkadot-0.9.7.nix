{ llvmPackages_12, pkgconfig, openssl, protobuf, rustPlatform }:
rustPlatform.buildRustPackage rec {
  pname = "polkadot";
  version = "0.9.7";

  cargoSha256 = "033dcv25kjniz7i3n072wrqam2g4krvnhd4svix27kz47pqz2y72";

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
}
