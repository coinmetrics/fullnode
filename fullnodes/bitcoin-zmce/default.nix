{ nixpkgs, version, runTests ? false }:
rec {
  package = with nixpkgs; stdenv.mkDerivation rec {
    pname = "bitcoin-zmce-cmfork";
    inherit version;

    src = fetchurl {
      urls = [
        "https://bitcoincore.org/bin/bitcoin-core-${version}/bitcoin-${version}.tar.gz"
        "https://bitcoin.org/bin/bitcoin-core-${version}/bitcoin-${version}.tar.gz"
      ];
      sha256 = {
        "0.20.0" = "ec5a2358ee868d845115dc4fc3ed631ff063c57d5e0a713562d083c5c45efb28";
        "0.21.0" = "1a91202c62ee49fb64d57a52b8d6d01cd392fffcbef257b573800f9289655f37";
      }.${version};
    };

    patches = {
      "0.20.0" = [ ./v0.20.0-zmce.patch ];
      "0.21.0" = [ ./v0.21.0-zmce.patch ];
    }.${version};

    nativeBuildInputs = [ pkgconfig autoreconfHook ];

    buildInputs = [ boost zlib zeromq libevent ];

    configureFlags = [
      "--with-boost-libdir=${boost.out}/lib"
      "--disable-shared"
      "--disable-wallet"
      "--disable-bench"
    ] ++ lib.optionals (!runTests) [
      "--disable-tests"
    ];

    checkInputs = [ hexdump python3 ];

    doCheck = runTests;

    enableParallelBuilding = true;
  };

  imageConfig = {
    config = {
      Entrypoint = [ "${package}/bin/bitcoind" ];
      User = "1000:1000";
    };

    extraCommands = ''
      mkdir ./bin && \
      ln -s ${nixpkgs.dash}/bin/dash ./bin/sh && \
      ln -s ${nixpkgs.gawk}/bin/awk ./bin/awk && \
      ln -s ${package}/bin/bitcoind ./bin/bitcoind && \
      ln -s ${package}/bin/bitcoin-cli ./bin/bitcoin-cli
    '';
  };
}
