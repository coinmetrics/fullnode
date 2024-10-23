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
  version = "21.1.1";

  src = fetchFromGitHub {
    owner = "dashpay";
    repo = "dash";
    rev = "v${version}";
    hash = "sha256-RSk/gl4RovWLGyyT/rSMFfDcxYFqDk31XTZLYA0UjT0=";
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
