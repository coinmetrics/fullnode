{ autoreconfHook
, boost
, db4
, fetchFromGitHub
, gmp
, hexdump
, libbacktrace
, libevent
, pkg-config
, stdenv
, zeromq
}:

stdenv.mkDerivation rec {
  pname = "dash";
  version = "23.1.10";

  src = fetchFromGitHub {
    owner = "dashpay";
    repo = "dash";
    rev = "v${version}";
    hash = "sha256-HNtld3i/ZKTlwSWKUkYvQz2lFLd9WaNpO/KkHU4lg0E=";
  };

  nativeBuildInputs = [
    autoreconfHook
    hexdump
    libbacktrace
    pkg-config
  ];

  buildInputs = [
    boost
    db4
    gmp
    libevent
    zeromq
  ];

  configureFlags = [
    "--with-boost-libdir=${boost.out}/lib"
  ];

  enableParallelBuilding = true;
}
