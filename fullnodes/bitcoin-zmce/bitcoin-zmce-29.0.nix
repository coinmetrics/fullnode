{ lib
, stdenv
, fetchurl
, cmake
, pkg-config
, installShellFiles
, autoSignDarwinBinariesHook
, wrapQtAppsHook ? null
, boost
, libevent
, miniupnpc
, zeromq
, zlib
, db48
, sqlite
, qrencode
, libsystemtap
, qtbase ? null
, qttools ? null
, python3
, versionCheckHook
, nixosTests
, withGui
, withWallet ? true
}:

with lib;
let
  version = "29.0";
  majorVersion = versions.major version;
  desktop = fetchurl {
    url = "https://raw.githubusercontent.com/bitcoin-core/packaging/${majorVersion}.x/debian/bitcoin-qt.desktop";
    sha256 = "0000000000000000000000000000000000000000000000000000";
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = if withGui then "bitcoin" else "bitcoind";
  inherit version;

  src = fetchurl {
    urls = [
      "https://bitcoincore.org/bin/bitcoin-core-${version}/bitcoin-${version}.tar.gz"
      "https://bitcoin.org/bin/bitcoin-core-${version}/bitcoin-${version}.tar.gz"
    ];
    sha256 = "sha256-iCx4LDSjvy6s0frlzcWLNbhpiDUS8Zf31tyPGV3s/ao=";
  };

  nativeBuildInputs =
    [
      cmake
      pkg-config
      installShellFiles
    ]
    ++ optionals stdenv.isDarwin [ hexdump ]
    ++ optionals (stdenv.isDarwin && stdenv.isAarch64) [ autoSignDarwinBinariesHook ]
    ++ optionals withGui [ wrapQtAppsHook ];

  buildInputs = [ boost libevent miniupnpc zeromq zlib ]
    ++ lib.optionals (stdenv.hostPlatform.isLinux) [ libsystemtap ]
    ++ optionals withWallet [ db48 sqlite ]
    ++ optionals withGui [ qrencode qtbase qttools ];

  patches = [
    ./patches/v29.0-zmce.patch
  ];

  postInstall = optionalString withGui ''
    install -Dm644 ${desktop} $out/share/applications/bitcoin-qt.desktop
    substituteInPlace $out/share/applications/bitcoin-qt.desktop --replace "Icon=bitcoin128" "Icon=bitcoin"
    install -Dm644 share/pixmaps/bitcoin256.png $out/share/pixmaps/bitcoin.png
  '';

  cmakeFlags =
    [
      (lib.cmakeBool "BUILD_BENCH" false)
      (lib.cmakeBool "WITH_ZMQ" true)
      # building with db48 (for legacy wallet support) is broken on Darwin
      (lib.cmakeBool "WITH_BDB" (withWallet && !stdenv.hostPlatform.isDarwin))
      (lib.cmakeBool "WITH_USDT" (stdenv.hostPlatform.isLinux))
    ]
    ++ lib.optionals (!finalAttrs.doCheck) [
      (lib.cmakeBool "BUILD_TESTS" true)
      (lib.cmakeBool "BUILD_FUZZ_BINARY" false)
      (lib.cmakeBool "BUILD_GUI_TESTS" false)
    ]
    ++ lib.optionals (!withWallet) [
      (lib.cmakeBool "ENABLE_WALLET" false)
    ]
    ++ lib.optionals withGui [
      (lib.cmakeBool "BUILD_GUI" true)
    ];

  # fix "Killed: 9  test/test_bitcoin"
  # https://github.com/NixOS/nixpkgs/issues/179474
  hardeningDisable = lib.optionals (stdenv.isAarch64 && stdenv.isDarwin) [ "stackprotector" ];

  nativeCheckInputs = [ python3 ];

  doCheck = true;

  checkFlags =
    [ "LC_ALL=en_US.UTF-8" ]
    # QT_PLUGIN_PATH needs to be set when executing QT, which is needed when testing Bitcoin's GUI.
    # See also https://github.com/NixOS/nixpkgs/issues/24256
    ++ optional withGui "QT_PLUGIN_PATH=${qtbase}/${qtbase.qtPluginPrefix}";

  enableParallelBuilding = true;

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgram = "${placeholder "out"}/bin/bitcoin-cli";
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  passthru.tests = {
    smoke-test = nixosTests.bitcoind;
  };

  meta = {
    description = "Peer-to-peer electronic cash system";
    longDescription = ''
      Bitcoin is a free open source peer-to-peer electronic cash system that is
      completely decentralized, without the need for a central server or trusted
      parties. Users hold the crypto keys to their own money and transact directly
      with each other, with the help of a P2P network to check for double-spending.
    '';
    homepage = "https://bitcoin.org/en/";
    downloadPage = "https://bitcoincore.org/bin/bitcoin-core-${version}/";
    changelog = "https://bitcoincore.org/en/releases/${version}/";
    maintainers = with maintainers; [ prusnak roconnor ];
    license = licenses.mit;
    platforms = platforms.unix;
  };
})
