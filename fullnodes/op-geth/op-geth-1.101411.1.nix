{ buildGoModule, fetchFromGitHub }:
buildGoModule rec {
  pname = "op-geth";
  version = "1.101411.1";

  src = fetchFromGitHub {
    owner = "ethereum-optimism";
    repo = "op-geth";
    rev = "v${version}";
    hash = "sha256-TPfeXakli8d0EqGgOnAmm/wEORvRcfr/KpuQ/rGragc=";
  };

  vendorHash = "sha256-IoHxdmXnm4P2Y3OgTv8qHM2pRId5pGmJt2tBli3aA1w=";

  proxyVendor = true;

  subPackages = [
    "cmd/geth"
  ];
}
