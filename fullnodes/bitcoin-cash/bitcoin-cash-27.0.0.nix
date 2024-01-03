{ stdenv, fetchFromGitLab, cmake, python3, openssl, boost, libevent, zeromq
, pkg-config, help2man, ninja }:

stdenv.mkDerivation rec {
  name = "bitcoin-cash-node";
  version = "27.0.0";

  src = fetchFromGitLab {
    owner = "bitcoin-cash-node";
    repo = "bitcoin-cash-node";
    rev = "v${version}";
    hash = "sha256-MbuXlPtbbB4hw4Pn0NT795PfCkkxCH+2fuVXcky7JEk=";
  };

  nativeBuildInputs = [ cmake python3 pkg-config help2man ninja ];

  buildInputs = [ openssl boost libevent zeromq ];

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
