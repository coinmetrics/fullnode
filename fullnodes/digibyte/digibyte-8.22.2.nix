{ lib,
stdenv,
fetchFromGitHub,
openssl,
boost,
libevent,
autoreconfHook,
db4,
pkg-config,
protobuf,
hexdump,
zeromq,
withGui ? true,
qtbase ? null,
qttools ? null,
wrapQtAppsHook ? null
}:

with lib;

stdenv.mkDerivation rec {
  pname = "digibyte";
  version = "8.22.2";

  name = pname + toString (optional (!withGui) "d") + "-" + version;

  src = fetchFromGitHub {
    owner = "DigiByte-Core";
    repo = "digibyte";
    rev = "refs/tags/v${version}";
    hash = "sha256-7ambzxGANqbKrBtrlaIHCwnowLH44QFCH0YiM4YVZ70=";
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
  ] ++ optionals withGui [
    qtbase
    qttools
    protobuf
  ];

  enableParallelBuilding = true;

  configureFlags = [
      "--with-boost-libdir=${boost.out}/lib"
  ] ++ optionals withGui [
      "--with-gui=qt5"
      "--with-qt-bindir=${qtbase.dev}/bin:${qttools.dev}/bin"
  ];

  postInstall = ''
    rm $out/bin/test_*
  '';

  dontWrapQtApps = withGui;
  preFixup = optionalString withGui ''
    wrapQtApp $out/bin/digibyte-qt
  '';

  meta = {
    description = "DigiByte (DGB) is a rapidly growing decentralized, global blockchain";
    homepage = "https://digibyte.io/";
    license = licenses.mit;
    maintainers = [ maintainers.mmahut ];
    platforms = platforms.linux;
  };
}
