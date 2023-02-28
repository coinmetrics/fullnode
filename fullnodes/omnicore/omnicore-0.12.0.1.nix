{ autoreconfHook, boost17x, db48, fetchFromGitHub, libevent, openssl, pkg-config
, stdenv }:
stdenv.mkDerivation rec {
  pname = "omnicore";
  version = "0.12.0.1";

  src = fetchFromGitHub {
    owner = "OmniLayer";
    repo = "omnicore";
    rev = "v${version}";
    hash = "sha256-bx3UK6gPd8Q0m5FB44Z3Dylw7VH1MgcON3FSILon45g=";
  };

  nativeBuildInputs = [ autoreconfHook pkg-config ];

  buildInputs = [ boost17x db48 libevent openssl ];

  configureFlags = [
    "--with-boost-libdir=${boost17x.out}/lib"
    "--disable-shared"
    "--disable-bench"
    "--disable-tests"
  ];

  doCheck = false;

  enableParallelBuilding = true;
}
