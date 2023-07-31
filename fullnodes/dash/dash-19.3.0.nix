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
  version = "19.3.0";

  src = fetchFromGitHub {
    owner = "dashpay";
    repo = "dash";
    rev = "refs/tags/v${version}";
    hash = "sha256-4nYPVRR6AhuIXe9zE21cLNIX7c3jopUyitRFJ8QRR6I=";
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
