{ nixpkgs, version }:
rec {
  package = with nixpkgs; stdenv.mkDerivation rec {
    pname = "vertcoin";
    inherit version;

    src = builtins.fetchGit {
      url = "https://github.com/vertcoin-project/vertcoin-core.git";
      ref = "refs/tags/${version}";
    };

    nativeBuildInputs = [ pkgconfig autoreconfHook ];

    buildInputs = [ boost libevent openssl ]
      ++ lib.optionals (lib.strings.versionAtLeast version "0.16.0") [ gmp ]
    ;

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
      Entrypoint = [ "${package}/bin/vertcoind" ];
      User = "1000:1000";
    };
  };
}
