{ stdenv, fetchFromGitHub, pkg-config, autoreconfHook, boost, libevent, openssl }:

stdenv.mkDerivation rec {
  pname = "bitcoin-sv";
  version = "1.0.13";

  src = fetchFromGitHub {
    owner = "bitcoin-sv";
    repo = "bitcoin-sv";
    rev = "v${version}";
    hash = "sha256-Jo0r2dXim/XObydVZOgY0HPAYNhUq97BeO2PBYVoxY8=";
  };

  nativeBuildInputs = [ pkg-config autoreconfHook ];

  buildInputs = [ boost libevent openssl ];

  configureFlags = [
    "--with-boost-libdir=${boost.out}/lib"
    "--disable-shared"
    "--disable-wallet"
    "--disable-bench"
    "--disable-tests"
  ];

  doCheck = false;

  enableParallelBuilding = true;
}
