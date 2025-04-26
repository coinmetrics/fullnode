{ buildGoModule, fetchFromGitHub }:
buildGoModule rec {
  pname = "op-geth";
  version = "1.101503.4";

  src = fetchFromGitHub {
    owner = "ethereum-optimism";
    repo = "op-geth";
    rev = "v${version}";
    hash = "sha256-QRtoJ/4JMKz8k4aZwNJK6XBfC8/u2Lh/rvDlYOIdY8Y=";
  };

  vendorHash = "sha256-L0zL+iHFYxPXbfT76M3jYIPAaokDauDLzj3MI4V/76M=";

  proxyVendor = true;

  subPackages = [
    "cmd/geth"
  ];
}
