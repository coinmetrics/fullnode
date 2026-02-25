{ buildGoModule, fetchFromGitHub }:
buildGoModule rec {
  pname = "op-geth";
  version = "1.101609.0";

  src = fetchFromGitHub {
    owner = "ethereum-optimism";
    repo = "op-geth";
    rev = "v${version}";
    hash = "sha256-lJJjUDcKavqJHRKKhSUK+TcrPYTlGi50MHas8KtzzoE=";
  };

  vendorHash = "sha256-XS9Z+dG/8P9CLkgBKWmhPORTWarufufHJ7zKwRhpaao=";

  proxyVendor = true;

  subPackages = [
    "cmd/geth"
  ];
}
