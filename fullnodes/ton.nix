{ nixpkgs, version }:
rec {
  package = with nixpkgs; stdenv.mkDerivation rec {
    pname = "ton";
    inherit version;

    src = builtins.fetchGit {
      url = "https://github.com/ton-blockchain/ton.git";
      ref = if version == "master" then version else "refs/tags/v${version}";
    };

    patches = [
      ./ton/use_nix_deps.patch
    ];

    nativeBuildInputs = [ pkgconfig cmake ];

    buildInputs = [ openssl libmicrohttpd zlib abseil-cpp crc32c rocksdb ];

    cmakeFlags = [
      "-DCMAKE_MODULE_PATH=${abseil-cpp}/lib/cmake;${crc32c}/lib/cmake;${rocksdb}/lib/cmake"
    ];
  };

  imageConfig = {
    config = {
      Entrypoint = [ "${package}/bin/validator-engine" ];
      User = "1000:1000";
    };
  };

  # clang stdenv
  stdenv = nixpkgs.overrideCC nixpkgs.stdenv nixpkgs.llvmPackages_9.tools.clang;

  # newer rocksdb
  rocksdb = nixpkgs.rocksdb.overrideAttrs (attrs: rec {
    version = "6.7.3";
    src = builtins.fetchGit {
      url = "https://github.com/facebook/rocksdb.git";
      ref = "v${version}";
    };
    patches = [];
  });
}
