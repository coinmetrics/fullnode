{ clang, cmake, darwin, fetchFromGitHub, fetchurl, lib, lighthouse, llvmPackages
, nodePackages, perl, protobuf, runCommand, rustPlatform, stdenv, testers, unzip }:
rustPlatform.buildRustPackage rec {
  pname = "lighthouse";
  version = "3.0.0";
  depositContractSpecVersion = "0.12.1";
  testnetDepositContractSpecVersion = "0.9.2.1";

  __darwinAllowLocalNetworking = true;

  src = fetchFromGitHub {
    owner = "sigp";
    repo = "lighthouse";
    rev = "v${version}";
    hash = "sha256-hbuVnaMjzlOe7s9lixGSZX1ndY5cnTHg0fhWe13tSIs=";
  };

  cargoPatches = [
    ./patches/3.0.0-coinmetrics-Cargo-lock.patch
  ];

  patches = [
    ./patches/3.0.0-coinmetrics.patch
  ];

  cargoHash = "sha256-zloGYqt6YcN5F1fhGSsH/UswERpjZdvmyuDvJPg+S94=";

  buildFeatures = [ "modern" "gnosis" ];

  checkFeatures = [ ];

  nativeBuildInputs = [ clang cmake nodePackages.ganache perl protobuf ];

  buildInputs = lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.Security
  ];

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
    "--package" "lighthouse"
  ];

  # All of these tests require network access
  cargoTestFlags = [
    "--workspace"
    "--exclude" "beacon_node"
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

  checkInputs = [
    nodePackages.ganache
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