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
    sha256 = "sha256-UFAVDYt/xqa1WTpSGdNc1hj6rIGu/Tk3lBvjI+E5MOI=";
  };

  cargoLock = {
    lockFile = ./5.3.0-Cargo.lock;
  };

  postPatch = ''
    cp ${./5.3.0-Cargo.lock} Cargo.lock
  '';

  nativeBuildInputs = [ llvmPackages_16.clang ];

  buildInputs = [ ncurses ];

  LIBCLANG_PATH = "${llvmPackages_16.libclang.lib}/lib";
}
