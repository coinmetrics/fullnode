{ boost17x, cmake, fetchFromGitHub, libsodium, ninja, openssl, pkgconfig, stdenv
, unbound, zeromq }:
stdenv.mkDerivation rec {
  pname = "monero";
  version = "0.18.0.0";

  src = fetchFromGitHub {
    owner = "monero-project";
    repo = "monero";
    rev = "b6a029f222abada36c7bc6c65899a4ac969d7dee";
    fetchSubmodules = true;
    sha256 = "sha256-GwHJIroRAKqBJ4wRiTtlKufirdYyGJ0cG/SB8prYAss=";
  };

  nativeBuildInputs = [ cmake ninja pkgconfig ];

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
