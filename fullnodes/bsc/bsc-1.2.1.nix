{ buildGo119Module, fetchFromGitHub }:
buildGo119Module rec {
  pname = "bsc";
  version = "1.2.1";

  src = fetchFromGitHub {
    owner = "bnb-chain";
    repo = "bsc";
    rev = "refs/tags/v${version}";
    hash = "sha256-oPxyBL0xcqf6PBxkL5zy3NxakvH+DOfShJoqcg8ne0s=";
  };

  vendorSha256 = "sha256-UFjaL4ygx5rWfnBv/PPkhmU+gD1xDKg4MnBcWOg0qMA=";
  proxyVendor = true;

  subPackages = [
    "cmd/geth"
  ];
}
