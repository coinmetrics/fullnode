{ buildGoModule, fetchFromGitHub }:
buildGoModule rec {
  pname = "op-geth";
  version = "1.101603.4";

  src = fetchFromGitHub {
    owner = "ethereum-optimism";
    repo = "op-geth";
    rev = "v${version}";
    hash = "sha256-wKcX8noJWx4wjuJKUB+Dc/idA5wq5U0UR4exIqLzxtw=";
  };

  vendorHash = "sha256-FjagD8htO1SvzrV2g6GVkbjMC5sLR81gY4jnMhZdfm0=";

  proxyVendor = true;

  subPackages = [
    "cmd/geth"
  ];
}
