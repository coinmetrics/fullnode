{ clang, cmake, fetchFromGitHub, fetchurl, lib, lighthouse, llvmPackages
, nodePackages, perl, protobuf, runCommand, rustPlatform, testers, unzip }:
rustPlatform.buildRustPackage rec {
  pname = "lighthouse";
  version = "2.5.1";
  depositContractSpecVersion = "0.12.1";
  testnetDepositContractSpecVersion = "0.9.2.1";

  src = fetchFromGitHub {
    owner = "sigp";
    repo = "lighthouse";
    rev = "v${version}";
    sha256 = "sha256-o8fntnEDRRtxDHsqHTJ3GoHpFtRpuwPQQJ+kxHV1NKA=";
  };

  cargoPatches = [
    ./patches/2.5.1-coinmetrics-Cargo-lock.patch
  ];

  cargoHash = "sha256-22aAqGf/cV1lx/7yS6N+ig+DaYhBW3dZksjnyGfZH74=";

  patches = [
    (fetchurl {
      url = "https://github.com/sigp/lighthouse/commit/e0f86588e634c186c0ab493694a8e4804fcbbf93.diff";
      hash = "sha256-0VTnSN0jt/FE/OwylEYmTu/OTJC8lwxhJd5whqCAeZk=";
    })
    ./patches/2.5.1-coinmetrics.patch
  ];

  buildFeatures = [ "modern" "gnosis" ];

  checkFeatures = [ ];

  nativeBuildInputs = [ clang cmake nodePackages.ganache perl protobuf ];

  LIBCLANG_PATH = "${llvmPackages.libclang.lib}/lib";

  depositContractSpec = fetchurl {
    url = "https://raw.githubusercontent.com/ethereum/eth2.0-specs/v${depositContractSpecVersion}/deposit_contract/contracts/validator_registration.json";
    hash = "sha256-ZslAe1wkmkg8Tua/AmmEfBmjqMVcGIiYHwi+WssEwa8=";
  };

  testnetDepositContractSpec = fetchurl {
    url = "https://raw.githubusercontent.com/sigp/unsafe-eth2-deposit-contract/v${testnetDepositContractSpecVersion}/unsafe_validator_registration.json";
    hash = "sha256-aeTeHRT3QtxBRSNMCITIWmx89vGtox2OzSff8vZ+RYY=";
  };

  LIGHTHOUSE_DEPOSIT_CONTRACT_SPEC_URL = "file://${depositContractSpec}";
  LIGHTHOUSE_DEPOSIT_CONTRACT_TESTNET_URL = "file://${testnetDepositContractSpec}";

  cargoBuildFlags = [
    "--workspace"
    "--exclude" "ef_tests"
    "--exclude" "web3signer_tests"
  ];

  # All of these tests require network access
  cargoTestFlags = [
    "--workspace"
    "--exclude" "beacon_node"
    "--exclude" "ef_tests"
    "--exclude" "http_api"
    "--exclude" "beacon_chain"
    "--exclude" "lighthouse"
    "--exclude" "lighthouse_network"
    "--exclude" "slashing_protection"
    "--exclude" "web3signer_tests"
  ];

  checkFlags = [
    "--skip" "service::tests::tests::test_dht_persistence"
  ];

  passthru.tests.version = testers.testVersion {
    package = lighthouse;
    command = "lighthouse --version";
    version = "v${lighthouse.version}";
  };

  meta = with lib; {
    description = "Ethereum consensus client in Rust";
    homepage = "https://lighthouse.sigmaprime.io/";
    license = licenses.asl20;
    maintainers = with maintainers; [ centromere ];
  };
}