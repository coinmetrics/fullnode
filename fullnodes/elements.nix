{ nixpkgs, version }:
rec {
  package = with nixpkgs; stdenv.mkDerivation rec {
    pname = "elements";
    inherit version;

    src = builtins.fetchGit {
      url = "https://github.com/ElementsProject/elements.git";
      ref = "refs/tags/elements-${version}";
    };

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
      Entrypoint = [ "${package}/bin/elementsd" ];
      User = "1000:1000";
    };
  };
}
