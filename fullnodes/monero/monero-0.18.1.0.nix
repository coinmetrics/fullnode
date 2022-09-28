{ boost17x, cmake, fetchFromGitHub, libsodium, ninja, openssl, pkg-config, stdenv
, unbound, zeromq }:
stdenv.mkDerivation rec {
  pname = "monero";
  version = "0.18.1.0";

  src = fetchFromGitHub {
    owner = "monero-project";
    repo = "monero";
    rev = "refs/tags/v${version}";
    fetchSubmodules = true;
    sha256 = "sha256-xniGiGqZpL1b6alnCxa2MNzuDQxPgMdNjqifOC8h0qM=";
  };

  nativeBuildInputs = [ cmake ninja pkg-config ];

  cmakeFlags = [
    "-DBUILD_TESTS=OFF"
    "-DARCH=x86-64"
    "-DBUILD_64=ON"
    "-DBUILD_TAG=linux-x64"
  ];

  configurePhase = "cmakeConfigurePhase";

  buildInputs = [ boost17x libsodium openssl unbound zeromq ];

  doCheck = false;

  enableParallelBuilding = true;
}
