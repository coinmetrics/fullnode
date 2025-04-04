{ stdenv, fetchFromGitLab, cmake, git, python3, openssl, boost, libevent, zeromq
, pkg-config, help2man, ninja, gmp, libnatpmp, zlib }:

stdenv.mkDerivation rec {
  name = "bitcoin-cash-node";
  version = "28.0.1";

  src = fetchFromGitLab {
    owner = "bitcoin-cash-node";
    repo = "bitcoin-cash-node";
    rev = "v${version}";
    hash = "sha256-FLTGcJROoo69ZkR+fzzXUox0gjbBNvFev4kY+Ji+mVA=";
  };

  nativeBuildInputs = [
    cmake
    python3
    pkg-config
    help2man
    ninja
    git
  ];

  buildInputs = [
    openssl
    boost
    gmp
    libevent
    libnatpmp
    zeromq
    zlib
  ];

  cmakeFlags = [
    "-DBUILD_BITCOIN_WALLET=OFF"
    "-DBUILD_BITCOIN_QT=OFF"
    "-DENABLE_UPNP=OFF"
    "-DENABLE_QRCODE=OFF"
  ];

  # many of the generated scripts lack execute permissions
  postConfigure = ''
    find ./. -type f -iname "*.sh" -exec chmod +x {} \;
    patchShebangs $TMPDIR/$sourceRoot/cmake/utils/gen-ninja-deps.py
    patchShebangs ./doc/man/gen-doc-man.sh
    patchShebangs ./doc/man/gen-doc-man-footer.sh
  '';

  enableParallelBuilding = true;
}
