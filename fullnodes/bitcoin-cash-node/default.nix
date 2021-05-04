{ nixpkgs, version }:
rec {
  package = with nixpkgs; stdenv.mkDerivation rec {
    pname = "bitcoin-cash-node";
    inherit version;

    src = fetchFromGitLab {
      owner = "bitcoin-cash-node";
      repo = "bitcoin-cash-node";
      rev = "v${version}";
      sha256 = {
        "22.1.0" = "1saxvlv6d1yx3vzvd7a9vahg0whw7izyi0nsdxw5m0v9l5r1f5m6";
        "22.2.0" = "09739pbzgilk8vdixr6vjkkg76crizdhi4ssz0fh9pwxc1jm6c65";
        "23.0.0" = "1jvx922l9gcxysdwjyi1q2wkhnhi8sg6s9npn49p77aji8jncjpf";
      }.${version} or lib.fakeSha256;
    };

    nativeBuildInputs = [ pkgconfig cmake python3 help2man ];

    buildInputs = [ boost libevent openssl zeromq ];

    cmakeFlags = [
      "-DBUILD_BITCOIN_WALLET=OFF"
      "-DBUILD_BITCOIN_QT=OFF"
      "-DENABLE_UPNP=OFF"
      "-DENABLE_QRCODE=OFF"
    ];

    # many of the generated scripts lack execute permissions
    postConfigure = ''
      find ./. -type f -iname "*.sh" -exec chmod +x {} \;
      patchShebangs ./doc/man/gen-doc-man.sh
      patchShebangs ./doc/man/gen-doc-man-footer.sh
    '';

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
