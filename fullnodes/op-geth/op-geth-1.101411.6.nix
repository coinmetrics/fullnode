{ buildGoModule, fetchFromGitHub }:
buildGoModule rec {
  pname = "op-geth";
  version = "1.101411.6";

  src = fetchFromGitHub {
    owner = "ethereum-optimism";
    repo = "op-geth";
    rev = "v${version}";
    hash = "sha256-9sc5kpQ/1B+3AdwEwthKwdK4HrOhSz7bga5pqyZpqr0=";
  };

  vendorHash = "sha256-EfgB88UUzGsI2uE1DAElV3d/cGGZEdZ67sZbYiw8pQk=";

  proxyVendor = true;

  subPackages = [
    "cmd/geth"
  ];
}
