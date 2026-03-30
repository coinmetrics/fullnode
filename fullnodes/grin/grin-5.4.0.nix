{ fetchFromGitHub
, fetchpatch
, llvmPackages_16
, ncurses
, rustPlatform
, rust-bin
, makeRustPlatform
}:

let
  toolchain = rust-bin.stable."1.88.0".default;
  rustPlatform' = makeRustPlatform {
    rustc = toolchain;
    cargo = toolchain;
  };
in
rustPlatform'.buildRustPackage rec {
  pname = "grin";
  version = "5.4.0";

  src = fetchFromGitHub {
    owner = "mimblewimble";
    repo = "grin";
    rev = "v${version}";
    hash = "sha256-AB4UKP9bM+eBcDGioFgFl8nlZnV2zygjJTL5y/RPTFo=";
  };

  cargoLock = {
    lockFile = ./5.4.0-Cargo.lock;
  };

  postPatch = ''
    cp ${./5.4.0-Cargo.lock} Cargo.lock
  '';

  nativeBuildInputs = [ llvmPackages_16.clang toolchain ];

  buildInputs = [ ncurses ];

  LIBCLANG_PATH = "${llvmPackages_16.libclang.lib}/lib";
}