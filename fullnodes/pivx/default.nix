{ nixpkgs, version }:
rec {
  package = with nixpkgs; stdenv.mkDerivation rec {
    pname = "pivx";
    inherit version;

    src = builtins.fetchGit {
      url = "https://github.com/PIVX-Project/PIVX.git";
      ref = "refs/tags/v${version}";
    };

    nativeBuildInputs = [ pkgconfig autoreconfHook ];

    buildInputs = [ boost libevent openssl gmp db48 ];

    configureFlags = [
      "--with-boost-libdir=${boost.out}/lib"
      "--disable-shared"
      # "--disable-wallet" # not implemented in pivx
      "--disable-bench"
      "--disable-tests"
    ];

    doCheck = false;

    enableParallelBuilding = true;
  };

  imageConfig = {
    config = {
      Entrypoint = [ "${package}/bin/pivxd" ];
      User = "1000:1000";
    };
  };
}
