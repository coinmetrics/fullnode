{ autoreconfHook, boost17x, fetchFromGitHub, gmp, libevent, openssl, pkg-config
, stdenv }:
stdenv.mkDerivation {
  pname = "vertcoin";
  version = "0.18.0";

  src = fetchFromGitHub {
    owner = "vertcoin-project";
    repo = "vertcoin-core";
    rev = "2bd6dba7a822400581d5a6014afd671fb7e61f36";
    sha256 = "sha256-ua9xXA+UQHGVpCZL0srX58DDUgpfNa+AAIKsxZbhvMk=";
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
