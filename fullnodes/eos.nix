{ nixpkgs, version }:
rec {
  # use clang
  stdenv = nixpkgs.overrideCC nixpkgs.stdenv nixpkgs.llvmPackages_9.tools.clang;

  # static boost
  boost = nixpkgs.boost.override {
    enableStatic = true;
    enableShared = false;
    inherit stdenv;
  };

  # expected llvm version
  llvm = if builtins.compareVersions version "2.0.0" < 0
    then nixpkgs.llvmPackages_4.llvm
    else nixpkgs.llvmPackages_9.llvm;

  package = with nixpkgs; stdenv.mkDerivation rec {
    pname = "eos";
    inherit version;

    src = fetchgit {
      url = "https://github.com/EOSIO/eos.git";
      rev = "refs/tags/v${version}";
      fetchSubmodules = true;
      sha256 = {
        "2.0.5" = "0nrq2mndrv35h44nbxpy5jcrvsc7mk17y58k3faf27p2j9b8pnsn";
      }.${version};
    };

    cmakeFlags = [ "-DVERSION_STRING=v${version}" ];

    patches = [
      ./eos/fix_appbase.patch
    ];

    nativeBuildInputs = [ cmake pkgconfig python git ];

    buildInputs = [ boost openssl llvm gmp curl libusb ];

    outputs = [ "bin" "dev" "lib" "out" ];

    doCheck = false;
  };

  nodeConfig = nixpkgs.writeText "config.ini" ''
    agent-name = "CoinMetricsAgent"

    # endpoints
    http-server-address = 0.0.0.0:8888
    p2p-listen-endpoint = 0.0.0.0:9876

    # increased sizes
    chain-state-db-size-mb = 65536
    reversible-blocks-db-size-mb = 2048

    # do not care about incoming Host header
    http-validate-host = false
    # log HTTP errors
    verbose-http-errors = true

    # plugins
    plugin = eosio::chain_api_plugin
    plugin = eosio::history_plugin
    plugin = eosio::history_api_plugin
    plugin = eosio::chain_plugin

    # increased response time
    http-max-response-time-ms = 1000

    ${ if builtins.compareVersions version "2.0.0" >= 0
      then ''
        # runtime
        wasm-runtime = eos-vm-jit
        eos-vm-oc-enable = true
        eos-vm-oc-compile-threads = 4
      ''
      else "" }
  '';

  genesisConfig = ./eos/genesis.json;

  imageConfig = {
    config = {
      Entrypoint = [ "${package}/bin/nodeos" "--config-dir" "/config" "--config" nodeConfig "--genesis-json" genesisConfig ];
      User = "1000:1000";
    };
    # no other easy way to make directory writable by user
    extraCommands = ''
      mkdir -p config
      chmod a+rw config
    '';
  };
}
