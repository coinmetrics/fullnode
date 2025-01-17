{ lib,
stdenv,
fetchFromGitHub,
openssl,
boost184,
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
  version = "8.22.0-final";

  name = pname + toString (optional (!withGui) "d") + "-" + version;

  src = fetchFromGitHub {
    owner = "DigiByte-Core";
    repo = "digibyte";
    rev = "v${version}";
    hash = "sha256-j2RpJ9ECFEhTK0NURI2cs6Urbs3tBIzvN2xTuz/6GdM=";
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
    boost184
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
      "--with-boost-libdir=${boost184.out}/lib"
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
