{ fetchFromGitHub
, fetchpatch
, llvmPackages_12
, ncurses
, rustPlatform
}:
rustPlatform.buildRustPackage {
  pname = "grin";
  version = "5.1.2";

  src = fetchFromGitHub {
    owner = "mimblewimble";
    repo = "grin";
    rev = "83e8ec65b3e5b2268b29e68dc1cdc1aa031e9147";
    sha256 = "sha256-yKOhQV0fSIJoOEgqb0ic371qnhGXGXZo8sCrkIYoDJU=";
  };

  cargoLock = {
    lockFile = ./patches/5.1.2-Cargo.lock;
  };

  patches = [
    (fetchpatch {
      name = "fix-leading-zeroes-bugs";
      url = "https://patch-diff.githubusercontent.com/raw/mimblewimble/grin/pull/3763.patch";
      hash = "sha256-xFUv0BhOSUbRZ7Q9As7aLcnOQCBiMr4HEyN//O2w9dU=";
    })
  ];

  postPatch = ''
    cp ${./patches/5.1.2-Cargo.lock} Cargo.lock
  '';

  nativeBuildInputs = [ llvmPackages_12.clang ];

  buildInputs = [ ncurses ];

  LIBCLANG_PATH = "${llvmPackages_12.libclang.lib}/lib";
}
