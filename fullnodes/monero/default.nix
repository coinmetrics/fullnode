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
        "0.17.1.7" = "1fdw4i4rw87yz3hz4yc1gdw0gr2mmf9038xaw2l4rrk5y50phjp4";
        "0.17.1.8" = "10blazbk1602slx3wrmw4jfgkdry55iclrhm5drdficc5v3h735g";
        "0.17.1.9" = "0jqss4csvkcrhrmaa3vrnyv6yiwqpbfw7037clx9xcfm4qrrfiwy";
        "0.17.2.3" = "0nax991fshfh51grhh2ryfrwwws35k16gzl1l3niva28zff2xmq6";
        "0.17.3.0" = "1spsf7m3x4psp9s7mivr6x4886jnbq4i8ll2dl8bv5bsdhcd3pjm";
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
