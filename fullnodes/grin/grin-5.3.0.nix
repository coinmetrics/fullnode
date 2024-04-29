{ fetchFromGitHub
, fetchpatch
, llvmPackages_16
, ncurses
, rustPlatform
}:
rustPlatform.buildRustPackage rec {
  pname = "grin";
  version = "5.3.0";

  src = fetchFromGitHub {
    owner = "mimblewimble";
    repo = "grin";
    rev = "v${version}";
    sha256 = "sha256-0000000000000000000000000000000000000000000=";
  };

  cargoLock = {
    lockFile = ./5.3.0-Cargo.lock;
  };

  patches = [
#    (fetchpatch {
#      name = "fix-leading-zeroes-bugs";
#      url = "https://patch-diff.githubusercontent.com/raw/mimblewimble/grin/pull/3763.patch";
#      hash = "sha256-xFUv0BhOSUbRZ7Q9As7aLcnOQCBiMr4HEyN//O2w9dU=";
#    })
  ];

  postPatch = ''
    cp ${./5.3.0-Cargo.lock} Cargo.lock
  '';

  nativeBuildInputs = [ llvmPackages_16.clang ];

  buildInputs = [ ncurses ];

  LIBCLANG_PATH = "${llvmPackages_16.libclang.lib}/lib";
}
