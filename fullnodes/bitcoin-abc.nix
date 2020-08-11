{ nixpkgs, version }:
rec {
  useCmakeBuild = builtins.compareVersions version "0.21.6" >= 0;

  package = with nixpkgs; stdenv.mkDerivation rec {
    pname = "bitcoin-abc";
    inherit version;

    src = builtins.fetchGit {
      url = "https://github.com/Bitcoin-ABC/bitcoin-abc.git";
      ref = "refs/tags/v${version}";
    };

    nativeBuildInputs = if useCmakeBuild
      then [ pkgconfig cmake python3 ]
      else [ pkgconfig autoreconfHook ];

    buildInputs = [ boost libevent openssl jemalloc ];

    configureFlags = lib.optionals (!useCmakeBuild) [
      "--with-boost-libdir=${boost.out}/lib"
      "--disable-shared"
      "--disable-wallet"
      "--disable-bench"
      "--disable-tests"
    ];

    cmakeFlags = lib.optionals useCmakeBuild [
      "-DBUILD_BITCOIN_WALLET=OFF"
      "-DBUILD_BITCOIN_QT=OFF"
      "-DBUILD_BITCOIN_ZMQ=OFF"
      "-DENABLE_UPNP=OFF"
    ];
    postConfigure = ''
      # not sure why it's broken
      find . -name 'build_native_*.sh' -exec chmod +x {} +
      find . -name 'run_native_*.sh' -exec chmod +x {} +
    '';

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
