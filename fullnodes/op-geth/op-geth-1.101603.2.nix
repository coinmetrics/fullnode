{ buildGoModule, fetchFromGitHub }:
buildGoModule rec {
  pname = "op-geth";
  version = "1.101603.2";

  src = fetchFromGitHub {
    owner = "ethereum-optimism";
    repo = "op-geth";
    rev = "v${version}";
    hash = "sha256-QQYah0L2/dWmgWj7YyDZsaTcsSiII7UXEpctwgsxEIY=";
  };

  vendorHash = "sha256-9tDum327vB86lARis7ZdAdQ0BdQGzxCtTyC4Dn189aU=";

  proxyVendor = true;

  subPackages = [
    "cmd/geth"
  ];
}
