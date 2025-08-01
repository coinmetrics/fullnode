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
  pname = "leap";
  version = "5.0.3";

  src = fetchFromGitHub {
    owner = "AntelopeIO";
    repo = "leap";
    rev = "v${version}";
    fetchSubmodules = true;
    leaveDotGit = true;
    hash = "sha256-13P48XHcSWwAHKGryohcez5QWhIRwqeO/PWEmZWEXRc=";
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
