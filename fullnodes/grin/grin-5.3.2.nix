{ fetchFromGitHub
, fetchpatch
, llvmPackages_16
, ncurses
, rustPlatform
}:
rustPlatform.buildRustPackage rec {
  pname = "grin";
  version = "5.3.2";

  src = fetchFromGitHub {
    owner = "mimblewimble";
    repo = "grin";
    rev = "v${version}";
    hash = "sha256-ao59alchBdRd8hSzEudsve5c7DKwC3BjjhWv815ah30=";
  };

  cargoLock = {
    lockFile = ./5.3.2-Cargo.lock;
  };

  postPatch = ''
    cp ${./5.3.2-Cargo.lock} Cargo.lock
  '';

  nativeBuildInputs = [ llvmPackages_16.clang ];

  buildInputs = [ ncurses ];

  LIBCLANG_PATH = "${llvmPackages_16.libclang.lib}/lib";
}
