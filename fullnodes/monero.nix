{ nixpkgs, version }:
rec {
  package = with nixpkgs; stdenv.mkDerivation rec {
    pname = "monero";
    inherit version;

    src = nixpkgs.fetchgit {
      url = "https://github.com/monero-project/monero.git";
      rev = "refs/tags/v${version}";
      fetchSubmodules = true;
      sha256 = {
        "0.15.0.5" = "06zzwa0y8ic6x3y2fy501788r51p4klanyvmm76ywrwf087njlkv";
      }.${version};
    };

    nativeBuildInputs = [ pkgconfig cmake ];

    buildInputs = [ boost openssl zeromq libsodium ];

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
      Entrypoint = [ "${package}/bin/monerod" ];
      User = "1000:1000";
    };
  };
}
