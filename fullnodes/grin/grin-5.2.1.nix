{ fetchFromGitHub
, fetchpatch
, llvmPackages_16
, ncurses
, rustPlatform
}:
rustPlatform.buildRustPackage rec {
  pname = "grin";
  version = "5.2.1";

  src = fetchFromGitHub {
    owner = "mimblewimble";
    repo = "grin";
    rev = "v${version}";
    sha256 = "sha256-5s0YgQfs8Z/sJDWj8THuryNk5RH8yOS6Wk7ntnQHGZw=";
  };

  cargoLock = {
    lockFile = ./5.2.1-Cargo.lock;
  };

  patches = [
#    (fetchpatch {
#      name = "fix-leading-zeroes-bugs";
#      url = "https://patch-diff.githubusercontent.com/raw/mimblewimble/grin/pull/3763.patch";
#      hash = "sha256-xFUv0BhOSUbRZ7Q9As7aLcnOQCBiMr4HEyN//O2w9dU=";
#    })
  ];

  postPatch = ''
    cp ${./5.2.1-Cargo.lock} Cargo.lock
  '';

  nativeBuildInputs = [ llvmPackages_16.clang ];

  buildInputs = [ ncurses ];

  LIBCLANG_PATH = "${llvmPackages_16.libclang.lib}/lib";
}
