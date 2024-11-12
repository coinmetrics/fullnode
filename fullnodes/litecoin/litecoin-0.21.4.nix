{ autoreconfHook
, boost177
, db48
, fetchFromGitHub
, fetchpatch
, fmt
, libevent
, openssl
, pkg-config
, stdenv
, zeromq }:
stdenv.mkDerivation rec {
  pname = "litecoin";
  version = "0.21.4";

  src = fetchFromGitHub {
    owner = "litecoin-project";
    repo = "litecoin";
    rev = "v${version}";
    hash = "sha256-39+lGWnsK2kq7iUveey98mMAVHCu4tWY8BEzY1rJZcU=";
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
