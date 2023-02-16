{ stdenv, fetchFromGitHub, pkg-config, autoreconfHook, boost, libevent, openssl }:

stdenv.mkDerivation rec {
  pname = "bitcoin-sv";
  version = "1.0.13";

  src = fetchFromGitHub {
    owner = "bitcoin-sv";
    repo = "bitcoin-sv";
    rev = "v${version}";
    hash = "sha256-n6qXTmsX3y23nntnRk0R/BwPQ/jerJkbFZk3ihbPpbY=";
  };

  patches = [
    ./patches/000-fix-missing-includes.patch
  ];

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
