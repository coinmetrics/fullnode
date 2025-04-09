{ buildGoModule, fetchFromGitHub }:
buildGoModule rec {
  pname = "op-geth";
  version = "1.101503.2";

  src = fetchFromGitHub {
    owner = "ethereum-optimism";
    repo = "op-geth";
    rev = "v${version}";
    hash = "sha256-ETHj983s0c3V2jkhzrFX9L4cXwVz6jd2HhQuqO9uRcs=";
  };

  vendorHash = "sha256-L0zL+iHFYxPXbfT76M3jYIPAaokDauDLzj3MI4V/76M=";

  proxyVendor = true;

  subPackages = [
    "cmd/geth"
  ];
}
