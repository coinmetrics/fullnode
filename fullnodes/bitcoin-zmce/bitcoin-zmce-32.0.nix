{ lib
, stdenv
, fetchurl
, fetchFromGitHub
, cmake
, pkg-config
, installShellFiles
, hexdump
, autoSignDarwinBinariesHook
, wrapQtAppsHook ? null
, boost
, libevent
, zeromq
, libsodium
, zlib
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
  version = "32.0";
  majorVersion = versions.major version;
  desktop = fetchurl {
    url = "https://raw.githubusercontent.com/bitcoin-core/packaging/${majorVersion}.x/debian/bitcoin-qt.desktop";
    sha256 = "0000000000000000000000000000000000000000000000000000";
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = if withGui then "bitcoin" else "bitcoind";
  inherit version;

  src = fetchFromGitHub {
    owner = "bitcoin";
    repo = "bitcoin";
    rev = "v${version}";
    hash = "sha256-iwvmaKm5hggCmeMCPeXS0an2sKxnGAhi02u1NJrw+Pk=";
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

  buildInputs = [ boost libevent zeromq libsodium zlib ]
    ++ lib.optionals (stdenv.hostPlatform.isLinux) [ libsystemtap ]
    ++ optionals withWallet [ sqlite ]
    ++ optionals withGui [ qrencode qtbase qttools ];

  patches = [
    ./patches/v32.0-zmce.patch
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
      (lib.cmakeBool "ENABLE_IPC" false)
      (lib.cmakeBool "WITH_USDT" (stdenv.hostPlatform.isLinux))
      (lib.cmakeBool "BUILD_TESTS" finalAttrs.doCheck)
      # The fuzz binary is never run here and is expensive to link.
      (lib.cmakeBool "BUILD_FUZZ_BINARY" false)
    ]
    ++ lib.optionals (!finalAttrs.doCheck) [
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
    (python3.withPackages (ps: [ ps.pyzmq ]))
  ];
  versionCheckProgram = "${placeholder "out"}/bin/bitcoin-cli";
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  # Run the functional test suite (including the ZMCE ZMQ publishers) against
  # the installed binaries, so that runtime linking issues are caught too.
  installCheckPhase = ''
    runHook preInstallCheck

    export BITCOIND=$out/bin/bitcoind
    export BITCOINCLI=$out/bin/bitcoin-cli
    # Each functional test spawns several bitcoind nodes, so running one test
    # per core OOMs on large CI runners. Cap the concurrency.
    jobs=$(( NIX_BUILD_CORES < 4 ? NIX_BUILD_CORES : 4 ))
    python3 test/functional/test_runner.py \
      --jobs=$jobs \
      --tmpdirprefix=$TMPDIR \
      --combinedlogslen=200 \
      --failfast

    runHook postInstallCheck
  '';

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
