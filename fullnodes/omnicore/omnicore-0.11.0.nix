{ autoreconfHook, boost17x, db48, fetchFromGitHub, libevent, openssl, pkgconfig
, stdenv }:
stdenv.mkDerivation rec {
  pname = "omnicore";
  version = "0.11.0";

  src = fetchFromGitHub {
    owner = "OmniLayer";
    repo = "omnicore";
    rev = "1c0ae8ae01ed79ae3715a16124e8acb98cb67800";
    sha256 = "sha256-hOsv2lrMhIm1oC6WNnc/1ednM90+uWSImbKq+Zwv6AE=";
  };

  nativeBuildInputs = [ autoreconfHook pkgconfig ];

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
