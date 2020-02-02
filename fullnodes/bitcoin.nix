{ nixpkgs, version }:
rec {
  package = with nixpkgs; stdenv.mkDerivation rec {
    pname = "bitcoin";
    inherit version;

    src = builtins.fetchTarball "https://bitcoincore.org/bin/bitcoin-core-${version}/bitcoin-${version}.tar.gz";

    nativeBuildInputs = [ pkgconfig autoreconfHook ];

    buildInputs = [ boost libevent openssl ];

    configureFlags = [
      "--with-boost-libdir=${boost.out}/lib"
      "--disable-shared"
      "--disable-wallet"
      "--disable-bench"
      "--disable-tests"
    ];

    doCheck = false;

    enableParallelBuilding = true;
  };

  imageConfig = {
    config = {
      Entrypoint = [ "${package}/bin/bitcoind" ];
      User = "1000:1000";
    };
  };
}
