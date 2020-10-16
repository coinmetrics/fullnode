{ nixpkgs, version }:
rec {
  package = with nixpkgs; stdenv.mkDerivation rec {
    pname = "bitcoin-cash-node";
    inherit version;

    src = builtins.fetchGit {
      url = "https://gitlab.com/bitcoin-cash-node/bitcoin-cash-node.git";
      ref = "refs/tags/v${version}";
    };

    nativeBuildInputs = [ pkgconfig cmake python3 ];

    buildInputs = [ boost libevent openssl ];

    cmakeFlags = [
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
