{ nixpkgs, version }:
rec {
  src = builtins.fetchGit {
    url = "https://github.com/PIVX-Project/PIVX.git";
    ref = "refs/tags/v${version}";
  };

  package = with nixpkgs; stdenv.mkDerivation rec {
    pname = "pivx";
    inherit version src;

    nativeBuildInputs = [ pkgconfig autoreconfHook ];

    buildInputs = [ boost libevent openssl gmp db48 libsodium ];

    patches = [
      ./build-fix.patch
    ];

    preAutoreconf = "sed -ie 's/: cargo-build/:/' src/Makefile.am";

    configureFlags = [
      "--with-boost-libdir=${boost.out}/lib"
      "--disable-shared"
      # "--disable-wallet" # not implemented in pivx
      "--disable-bench"
      "--disable-tests"
      "--disable-online-rust"
    ];

    makeFlags = "LIBRUSTZCASH=${librustzcash}/lib/librustzcash.a";

    doCheck = false;

    enableParallelBuilding = true;
  };

  imageConfig = {
    config = {
      Entrypoint = [ "${package}/bin/pivxd" "-paramsdir=${package}/share/pivx" ];
      User = "1000:1000";
    };
  };

  librustzcash = nixpkgs.rustPlatform.buildRustPackage rec {
    pname = "pivx-librustzcash";
    inherit version src;

    cargoSha256 = {
      "5.1.0"   = "03y86bb1i0b10wj374rcd8cazsp2ipf0bhddhjj58rwfb14n4h8l";
      "5.2.0.1" = "1xx5qk3hjvygirkbh3zdj378v9bd88cwk8xmdjpmwrz9xkc6n5r8";
    }.${version} or (builtins.trace "PIVX librustzcash: using dummy cargo SHA256" "0000000000000000000000000000000000000000000000000000");

    proxyVendor = true;
    doCheck = false;
  };
}
