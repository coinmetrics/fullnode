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
        "0.16.0.0" = "0x74h5z0nxxxip97ibc854pqmrgd8r4d6w62m424f66i8gbzfskh";
        "0.16.0.1" = "0n2cviqm8radpynx70fc0819k1xknjc58cvb4whlc49ilyvh8ky6";
        "0.16.0.3" = "1r9x3712vhb24dxxirfiwj5f9x0h4m7x0ngiiavf5983dfdlgz33";
        "0.17.0.0" = "1mpxfpbfr6gv1acw8wyxfk5i1i3p63lm8gi88xhb42s1vakvp7ad";
        "0.17.0.1" = "1v0phvg5ralli4dr09a60nq032xqlci5d6v4zfq8304vgrn1ffgp";
      }.${version} or (builtins.trace "Monero fullnode: using dummy SHA256" "0000000000000000000000000000000000000000000000000000");
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
