{ buildGoModule, fetchFromGitHub }:
buildGoModule rec {
  pname = "op-geth";
  version = "1.101602.0";

  src = fetchFromGitHub {
    owner = "ethereum-optimism";
    repo = "op-geth";
    rev = "v${version}";
    hash = "sha256-eRYRg7c6BT7+I1SVGqDt1RQsSRaSHgrLABw44FAdyBc=";
  };

  vendorHash = "sha256-AI+SqIuFgNOzIapu6Y6zrmRf8Sy2bvlVEgvpowkeyLU=";

  proxyVendor = true;

  subPackages = [
    "cmd/geth"
  ];
}
