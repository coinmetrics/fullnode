{ autoreconfHook, boost17x, fetchFromGitHub, gmp, libevent, openssl, pkg-config
, stdenv }:
stdenv.mkDerivation rec {
  pname = "vertcoin";
  version = "22.1";

  src = fetchFromGitHub {
    owner = "vertcoin-project";
    repo = "vertcoin-core";
    rev = "v${version}";
    hash = "sha256-0iopWE+FoOgRgeXAtDsbEJR72zJffSn2f0pO8G2YT/8=";
  };

  nativeBuildInputs = [ autoreconfHook pkg-config ];

  buildInputs = [ boost17x gmp libevent openssl ];

  configureFlags = [
    "--with-boost-libdir=${boost17x.out}/lib"
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
