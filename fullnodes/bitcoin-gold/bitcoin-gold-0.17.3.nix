{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, openssl
, boost
, libb2
, libevent
, autoreconfHook
, db4
, pkg-config
, protobuf
, hexdump
, zeromq
, libsodium
, withGui
, withWallet
, qtbase ? null
, qttools ? null
, wrapQtAppsHook ? null
}:

with lib;

stdenv.mkDerivation rec {
  pname = "bitcoin" + toString (optional (!withGui) "d") + "-gold";
  version = "0.17.3";

  src = fetchFromGitHub {
    owner = "BTCGPU";
    repo = "BTCGPU";
    # This commit fixes build errors under Nix
    #rev = "v${version}";
    rev = "edbdf2b33989891cb57a04c78ea18bcb66ab60eb";
    sha256 = "sha256-2VOf1uRRzqObW/WZ7bjDy1OeFpfSFO37EDjMmyaU2w4=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    hexdump
  ] ++ optionals withGui [
    wrapQtAppsHook
  ];

  buildInputs = [
    openssl
    boost
    libevent
    db4
    zeromq
    libsodium
    libb2
  ] ++ optionals withGui [
    qtbase
    qttools
    protobuf
  ];

  enableParallelBuilding = true;

  patches = [
    ./patches/build-fix.patch
  ];

  configureFlags = [
      "--with-boost-libdir=${boost.out}/lib"
  ] ++ optionals withGui [
      "--with-gui=qt5"
      "--with-qt-bindir=${qtbase.dev}/bin:${qttools.dev}/bin"
  ] ++ optional (!withWallet) "--disable-wallet";

  meta = {
    description = "BTG is a cryptocurrency with Bitcoin fundamentals, mined on common GPUs instead of specialty ASICs";
    homepage = "https://bitcoingold.org/";
    license = licenses.mit;
    maintainers = [ maintainers.mmahut ];
    platforms = platforms.linux;
  };
}
