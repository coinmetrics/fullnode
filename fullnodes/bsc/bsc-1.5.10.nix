{ buildGoModule, fetchFromGitHub }:
buildGoModule rec {
  pname = "bsc";
  version = "1.5.10";

  src = fetchFromGitHub {
    owner = "bnb-chain";
    repo = "bsc";
    rev = "refs/tags/v${version}";
    hash = "sha256-srus7aWZOjpBUhl7LDtW4WqAoQ5IL/9frnsdBNcF/fM=";
  };

  vendorHash = "sha256-JGhXk6s3nCk04N6auTy1n1H6ZBbRk1K6I07LEW1kWSk=";
  proxyVendor = true;

  subPackages = [
    "cmd/geth"
  ];
}
