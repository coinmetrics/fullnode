{ buildGoModule, fetchFromGitHub }:
buildGoModule rec {
  pname = "op-geth";
  version = "1.101503.1";

  src = fetchFromGitHub {
    owner = "ethereum-optimism";
    repo = "op-geth";
    rev = "v${version}";
    hash = "sha256-6PS6vUy91Z5ryS6xLltvvwCuStBPrFv9E3T+WW0miU8=";
  };

  vendorHash = "sha256-L0zL+iHFYxPXbfT76M3jYIPAaokDauDLzj3MI4V/76M=";

  proxyVendor = true;

  subPackages = [
    "cmd/geth"
  ];
}
