{ buildGoModule, fetchFromGitHub }:
buildGoModule rec {
  pname = "bsc";
  version = "1.4.17";

  src = fetchFromGitHub {
    owner = "bnb-chain";
    repo = "bsc";
    rev = "refs/tags/v${version}";
    hash = "sha256-4duJzYxdSG3udXc1rpvv7Xe6uJrXZNrJRPfZfffEKS4=";
  };

  vendorHash = "sha256-4irfVqv1v9Ff1H9KRB4BUmceLqdKdhBbUUouGrB6mqU=";
  proxyVendor = true;

  subPackages = [
    "cmd/geth"
  ];
}
