{ buildGoModule, fetchFromGitHub }:
buildGoModule rec {
  pname = "bsc";
  version = "1.4.15";

  src = fetchFromGitHub {
    owner = "bnb-chain";
    repo = "bsc";
    rev = "refs/tags/v${version}";
    hash = "sha256-v10ZQDgwASBh1YskUPr+eZgf6qb/y8jEpTuJfsnwl+Q=";
  };

  vendorHash = "sha256-4irfVqv1v9Ff1H9KRB4BUmceLqdKdhBbUUouGrB6mqU=";
  proxyVendor = true;

  subPackages = [
    "cmd/geth"
  ];
}
