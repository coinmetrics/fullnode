{ fetchFromGitHub, llvmPackages_12, ncurses, rustPlatform }:
rustPlatform.buildRustPackage {
  pname = "grin";
  version = "5.1.2";

  cargoSha256 = "sha256-LQWO50XCaq+gYtsX4sZtWineKRLw14PjZMnCTzckifg=";

  src = fetchFromGitHub {
    owner = "mimblewimble";
    repo = "grin";
    rev = "83e8ec65b3e5b2268b29e68dc1cdc1aa031e9147";
    sha256 = "sha256-yKOhQV0fSIJoOEgqb0ic371qnhGXGXZo8sCrkIYoDJU=";
  };

  nativeBuildInputs = [ llvmPackages_12.clang ];

  buildInputs = [ ncurses ];

  LIBCLANG_PATH = "${llvmPackages_12.libclang.lib}/lib";
}
