{ nixpkgs, version }:
rec {
  package = with nixpkgs; stdenv.mkDerivation rec {
    pname = "omnicore";
    inherit version;

    # temp hack for pre-release version
    src = if version == "0.8.0-develop"
      then
    builtins.fetchGit {
      url = "https://github.com/OmniLayer/omnicore.git";
      ref = "develop";
      rev = "70fe939da40a67f8ab056e64f0e7ba67f6cdd0f9";
    }
      else
    builtins.fetchGit {
      url = "https://github.com/OmniLayer/omnicore.git";
      ref = "refs/tags/v${version}";
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
      Entrypoint = [ "${package}/bin/omnicored" ];
      User = "1000:1000";
    };
  };
}
