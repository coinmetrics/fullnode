{ buildGoModule, fetchFromGitHub }:
buildGoModule rec {
  pname = "op-geth";
  version = "1.101603.5";

  src = fetchFromGitHub {
    owner = "ethereum-optimism";
    repo = "op-geth";
    rev = "v${version}";
    hash = "sha256-W917yjvFgWP6zMi1sgHEuqpOv80iSenPnXXeLcgVwrE=";
  };

  vendorHash = "sha256-FjagD8htO1SvzrV2g6GVkbjMC5sLR81gY4jnMhZdfm0=";

  proxyVendor = true;

  subPackages = [
    "cmd/geth"
  ];
}
