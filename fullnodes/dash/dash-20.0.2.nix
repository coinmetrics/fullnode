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
  version = "20.0.2";

  src = fetchFromGitHub {
    owner = "dashpay";
    repo = "dash";
    rev = "v${version}";
    hash = "sha256-Its3z5UFg3LuLIcBSlQ3vuGvi0hHIlO4DsS2gz+nhBA=";
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
