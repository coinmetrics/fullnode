{ buildGoModule, fetchFromGitHub }:
buildGoModule rec {
  pname = "op-geth";
  version = "1.101602.3";

  src = fetchFromGitHub {
    owner = "ethereum-optimism";
    repo = "op-geth";
    rev = "v${version}";
    hash = "sha256-JyP6Pxp1i9ew8InNHqz7k6Jp4iLlvsSr9unj0Ws/fe0=";
  };

  vendorHash = "sha256-AI+SqIuFgNOzIapu6Y6zrmRf8Sy2bvlVEgvpowkeyLU=";

  proxyVendor = true;

  subPackages = [
    "cmd/geth"
  ];
}
