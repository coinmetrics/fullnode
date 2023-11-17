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
  version = "0.11.0";

  src = fetchFromGitHub {
    owner = "OmniLayer";
    repo = "omnicore";
    rev = "1c0ae8ae01ed79ae3715a16124e8acb98cb67800";
    sha256 = "sha256-hOsv2lrMhIm1oC6WNnc/1ednM90+uWSImbKq+Zwv6AE=";
  };

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
