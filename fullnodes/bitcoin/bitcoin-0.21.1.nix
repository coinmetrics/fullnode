{ autoreconfHook, boost, fetchzip, lib, libevent, pkg-config, stdenv }:
stdenv.mkDerivation rec {
  pname = "bitcoin";
  version = "0.21.1";

  src = fetchzip {
    url = "https://bitcoincore.org/bin/bitcoin-core-${version}/bitcoin-${version}.tar.gz";
    sha256 = "sha256-FbU/XmehxBjiBxFDo5XjimTc9EAIEh/75tE0CK8+jG4=";
  };

  nativeBuildInputs = [ pkg-config autoreconfHook ];

  buildInputs = [ boost libevent ];

  configureFlags = [
    "--with-boost-libdir=${boost.out}/lib"
    "--disable-shared"
    "--disable-wallet"
    "--disable-bench"
    "--disable-tests"
  ];

  doCheck = false;

  enableParallelBuilding = true;
}
