{ cmake
, curl
, fetchFromGitHub
, gmp
, llvm
, llvmPackages
, ninja
, python3
, stdenv
}:

llvmPackages.stdenv.mkDerivation rec {
  pname = "leap";
  version = "5.0.0";

  src = fetchFromGitHub {
    owner = "AntelopeIO";
    repo = "leap";
    rev = "v${version}";
    hash = "sha256-X4x8z/xvFrL7I7LRmElYzIWL7Nq9kMkm8VfPzPhVtYk=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    cmake
    curl
    ninja
    llvm
    python3
  ];

  buildInputs = [
    gmp
  ];
}
