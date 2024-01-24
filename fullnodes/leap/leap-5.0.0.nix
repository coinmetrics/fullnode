{ cmake
, curl
, fetchFromGitHub
, git
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
    fetchSubmodules = true;
    leaveDotGit = true;
    hash = "sha256-mzEAkylaF0LQmjdQ93gLOmDFK4yZvzj6uvS0Le8f0G8=";
  };

  nativeBuildInputs = [
    cmake
    curl
    git
    ninja
    llvm
    python3
  ];

  buildInputs = [
    gmp
  ];
}
