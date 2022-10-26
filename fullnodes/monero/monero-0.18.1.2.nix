{ boost17x, cmake, fetchFromGitHub, libsodium, ninja, openssl, pkg-config, stdenv
, unbound, zeromq }:
stdenv.mkDerivation rec {
  pname = "monero";
  version = "0.18.1.2";

  src = fetchFromGitHub {
    owner = "monero-project";
    repo = "monero";
    rev = "refs/tags/v${version}";
    fetchSubmodules = true;
    hash = "sha256-yV1ysoesEcjL+JX6hkmcrBDmazOWBvYK6EjshxJzcAw=";
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
