{ boost177
, cmake
, fetchFromGitHub
, libsodium
, ninja
, openssl
, pkg-config
, stdenv
, unbound
, zeromq }:

stdenv.mkDerivation rec {
  pname = "monero";
  version = "0.18.3.1";

  src = fetchFromGitHub {
    owner = "monero-project";
    repo = "monero";
    rev = "refs/tags/v${version}";
    fetchSubmodules = true;
    hash = "sha256-ndeCYOgy8dzsP8YAIm+tEj4ndrpVTsRLmk7juvXL1cw=";
  };

  nativeBuildInputs = [ cmake ninja pkg-config ];

  cmakeFlags = [
    "-DBUILD_TESTS=OFF"
    "-DARCH=x86-64"
    "-DBUILD_64=ON"
    "-DBUILD_TAG=linux-x64"
  ];

  configurePhase = "cmakeConfigurePhase";

  buildInputs = [ boost177 libsodium openssl unbound zeromq ];

  enableParallelBuilding = true;
}
