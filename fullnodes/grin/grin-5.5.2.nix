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
  version = "5.5.2";

  src = fetchFromGitHub {
    owner = "mimblewimble";
    repo = "grin";
    rev = "v${version}";
    hash = "sha256-PS98utrCRrWgc/qMzoOL3An4lASCiuZ3yBpTWefN9p8=";
  };

  cargoLock = {
    lockFile = ./5.5.2-Cargo.lock;
  };

  postPatch = ''
    cp ${./5.5.2-Cargo.lock} Cargo.lock
  '';

  nativeBuildInputs = [ llvmPackages_16.clang toolchain ];

  buildInputs = [ ncurses ];

  LIBCLANG_PATH = "${llvmPackages_16.libclang.lib}/lib";
}