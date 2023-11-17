{ autoreconfHook
, boost177
, fetchFromGitHub
, gmp
, libevent
, openssl
, pkg-config
, stdenv }:
stdenv.mkDerivation rec {
  pname = "vertcoin";
  version = "23.2";

  src = fetchFromGitHub {
    owner = "vertcoin-project";
    repo = "vertcoin-core";
    rev = "v${version}";
    hash = "sha256-IhTNVKsvTAfnB1OT68uPMnbqSrZJfHPKWg3tnFsOGfk=";
  };

  nativeBuildInputs = [ autoreconfHook pkg-config ];

  buildInputs = [ boost177 gmp libevent openssl ];

  configureFlags = [
    "--with-boost-libdir=${boost177.out}/lib"
    "--disable-shared"
    "--disable-wallet"
    "--disable-bench"
    "--disable-tests"
    "--enable-cxx"
    "--with-pic"
  ];

  doCheck = false;

  enableParallelBuilding = true;
}
