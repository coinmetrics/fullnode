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
  version = "22.1.2";

  src = fetchFromGitHub {
    owner = "dashpay";
    repo = "dash";
    rev = "v${version}";
    hash = "sha256-cPxa/lEEg5w3fN0lgsxDQR4LaCvWJN7veswsVG7MCBs=";
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
