{ stdenv, fetchFromGitHub, pkg-config, autoreconfHook, boost, libevent, openssl }:

stdenv.mkDerivation rec {
  pname = "bitcoin-sv";
  version = "1.0.11";

  src = fetchFromGitHub {
    owner = "bitcoin-sv";
    repo = "bitcoin-sv";
    rev = "v${version}";
    sha256 = "sha256-SEACxqj8IcWeMNRnbV/5fKdpi1BQcE9e+1FDtCIyVc4=";
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
