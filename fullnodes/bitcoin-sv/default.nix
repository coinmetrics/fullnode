{ nixpkgs, version }:
rec {
  package = with nixpkgs; (overrideCC stdenv gcc9).mkDerivation rec {
    pname = "bitcoin-sv";
    inherit version;

    src = builtins.fetchGit {
      url = "https://github.com/bitcoin-sv/bitcoin-sv.git";
      ref = "refs/tags/v${version}";
    };

    patches =
      nixpkgs.lib.optional (builtins.compareVersions version "1.0.1" == 0) ./1.0.1-fix-json.patch ++
      nixpkgs.lib.optional (builtins.compareVersions version "1.0.6" < 0) (nixpkgs.fetchpatch {
        url = "https://github.com/bitcoin-sv/bitcoin-sv/commit/4b4351db791d58457e4f03b24aaf0cc74288a03e.diff";
        sha256 = "0v5rbrwf3xpnk763qvzfgi6s9k7ss588jl0cdgkgi04s0nh0yjbw";
      });

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
