{ autoreconfHook
, boost177
, db48
, fetchFromGitHub
, libevent
, openssl
, pkg-config
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

  patches = [
    ./patches/fix-build.patch
  ];

  nativeBuildInputs = [ autoreconfHook pkg-config ];

  buildInputs = [ boost177 db48 libevent openssl ];

  configureFlags = [
    "--with-boost-libdir=${boost177.out}/lib"
    "--disable-shared"
    "--disable-bench"
    "--disable-tests"
  ];

  doCheck = false;

  enableParallelBuilding = true;
}
