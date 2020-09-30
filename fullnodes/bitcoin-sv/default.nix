{ nixpkgs, version }:
rec {
  package = with nixpkgs; stdenv.mkDerivation rec {
    pname = "bitcoin-sv";
    inherit version;

    src = builtins.fetchTarball "https://download.bitcoinsv.io/bitcoinsv/${version}/bitcoin-sv-${version}.tar.gz";

    patches = nixpkgs.lib.optional (builtins.compareVersions version "1.0.1" == 0) ./1.0.1-fix-json.patch;

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
