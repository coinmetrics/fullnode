{ nixpkgs, version }:
rec {
  package = with nixpkgs; stdenv.mkDerivation rec {
    pname = "bitcoin-gold";
    inherit version;

    src = builtins.fetchGit {
      url = "https://github.com/BTCGPU/BTCGPU.git";
      ref = "refs/tags/v${version}";
    };

    nativeBuildInputs = [ pkgconfig autoreconfHook ];

    buildInputs = [ boost libevent openssl libsodium libb2 ];

    configureFlags = [
      "--with-boost-libdir=${boost.out}/lib"
      "--disable-shared"
      "--disable-wallet"
      "--disable-bench"
      "--disable-tests"
    ];

    patches =
      # https://github.com/BTCGPU/BTCGPU/commit/ac59db66c0c7631fedd1150c2b61bd1c2878f8c9
      nixpkgs.lib.optional (builtins.compareVersions version "0.17.3" < 0) (nixpkgs.fetchpatch {
        url = "https://github.com/BTCGPU/BTCGPU/commit/ac59db66c0c7631fedd1150c2b61bd1c2878f8c9.diff";
        sha256 = "1l2dqcdnfkpjs5k7yxg72601j6916zaxbb9b194qrz1nqjrw5mj2";
      });

    doCheck = false;

    enableParallelBuilding = true;
  };

  imageConfig = {
    config = {
      Entrypoint = [ "${package}/bin/bgoldd" ];
      User = "1000:1000";
    };
  };
}
