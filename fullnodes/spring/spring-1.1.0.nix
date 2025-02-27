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
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "AntelopeIO";
    repo = "spring";
    rev = "v${version}";
    fetchSubmodules = true;
    leaveDotGit = true;
    hash = "sha256-2WXfazrWSjE3kaW4TXiHQTZMVo4N4Aj7HIs4W/HQ1qs=";
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
