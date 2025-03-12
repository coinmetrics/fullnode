{ buildGoModule, fetchFromGitHub }:
buildGoModule rec {
  pname = "op-geth";
  version = "1.101503.0";

  src = fetchFromGitHub {
    owner = "ethereum-optimism";
    repo = "op-geth";
    rev = "v${version}";
    hash = "sha256-cOJEp7oQaDNyp1M1zeZ5fywf8xs2ypA8AgSPrMPwzlY=";
  };

  vendorHash = "sha256-L0zL+iHFYxPXbfT76M3jYIPAaokDauDLzj3MI4V/76M=";

  proxyVendor = true;

  subPackages = [
    "cmd/geth"
  ];
}
