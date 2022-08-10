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

  cargoHash = "sha256-oyX+v2dJ54GXd0XdesZC/zw7FXtFfx6qOJgX4OJLR+A=";

  patches = [
    (fetchurl {
      url = "https://github.com/sigp/lighthouse/commit/3c2a6392ee626e8b945efa84d08a906029c582a2.diff";
      hash = "sha256-dwp7vkwlm2ZhGm1/uhdH71FmCIJyT3lB/NYMKYLxmA8=";
    })
  ];

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
    "--exclude" "beacon_node"
    "--exclude" "ef_tests"
    "--exclude" "http_api"
    "--exclude" "beacon_chain"
    "--exclude" "lighthouse"
    "--exclude" "lighthouse_network"
    "--exclude" "slashing_protection"
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
    platforms = platforms.linux;
  };
}
