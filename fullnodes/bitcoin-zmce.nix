{ nixpkgs, version }:
rec {
  package = with nixpkgs; stdenv.mkDerivation rec {
    pname = "bitcoin-zmce-cmfork";
    inherit version;

    src = builtins.fetchTarball "https://bitcoincore.org/bin/bitcoin-core-${version}/bitcoin-${version}.tar.gz";

    patches = {
      "0.19.1" = [ ./bitcoin-zmce/v0.19.1-zmq-mempool-chain-events.patch ];
      "0.20.0" = [ ./bitcoin-zmce/v0.20.0-zmce.patch ];
    }.${version};

    nativeBuildInputs = [ pkgconfig autoreconfHook ];

    buildInputs = [ boost libevent openssl zeromq ];

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
