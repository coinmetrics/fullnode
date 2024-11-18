{ cmake
, curl
, fetchFromGitHub
, gcc
, git
, gmp
, llvm
, ninja
, overrideCC
, python3
, stdenv
}:

(overrideCC stdenv gcc).mkDerivation rec {
  pname = "spring";
  version = "1.0.3";

  src = fetchFromGitHub {
    owner = "AntelopeIO";
    repo = "spring";
    rev = "v${version}";
    fetchSubmodules = true;
    leaveDotGit = true;
    hash = "sha256-Wo1rKn4Rnx4AjExk2ygada8tqv96pCbJQxtz9s2DKTY";
  };

  patches = [
    ./patches/fix-threading-issue.patch
  ];

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

  separateDebugInfo = true;

  # Some individual source files require many GB of memory
  enableParallelBuilding = false;
}
