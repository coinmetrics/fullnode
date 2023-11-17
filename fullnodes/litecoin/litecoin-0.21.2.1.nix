{ autoreconfHook
, boost177
, db48
, fetchFromGitHub
, fmt
, libevent
, openssl
, pkg-config
, stdenv
, zeromq }:
stdenv.mkDerivation rec {
  pname = "litecoin";
  version = "0.21.2.1";

  src = fetchFromGitHub {
    owner = "litecoin-project";
    repo = "litecoin";
    rev = "fce5d459f0a83f56a83059c5c69295d7745b51d2";
    sha256 = "sha256-WJFdac5hGrHy9o3HzjS91zH+4EtJY7kUJAQK+aZaEyo=";
  };

  nativeBuildInputs = [ autoreconfHook pkg-config ];

  buildInputs = [ boost177 db48 fmt libevent openssl zeromq ];

  configureFlags = [
    "--with-boost-libdir=${boost177.out}/lib"
    "--disable-shared"
    "--disable-wallet"
    "--disable-bench"
    "--disable-tests"
  ];

  doCheck = false;

  enableParallelBuilding = true;
}
