{ buildGoModule, fetchFromGitHub }:
buildGoModule rec {
  pname = "bsc";
  version = "1.5.7";

  src = fetchFromGitHub {
    owner = "bnb-chain";
    repo = "bsc";
    rev = "refs/tags/v${version}";
    hash = "sha256-ZBHMeHiG3epJzlq1IulOe+sIUBb8LScDptYov+GY5ic=";
  };

  vendorHash = "sha256-nWfLkaw2hGN/prljjJw1j5xjncg2mlDBCHcYXXxOTZE=";
  proxyVendor = true;

  subPackages = [
    "cmd/geth"
  ];
}
