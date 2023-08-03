{ buildGo119Module, fetchFromGitHub }:
buildGo119Module rec {
  pname = "bsc";
  version = "1.2.10";

  src = fetchFromGitHub {
    owner = "bnb-chain";
    repo = "bsc";
    rev = "refs/tags/v${version}";
    hash = "sha256-JVxAWNRoul0JxtYwF7hJz6ubi+w0WBW63P44ykVk3xY=";
  };

  #vendorHash = "sha256-0000000000000000000000000000000000000000000=";
  vendorHash = "sha256-vM0vP1od4l6a4e0LHZdUnzxz5LRkKPhqMhr4nCIzVIg=";
  proxyVendor = true;

  subPackages = [
    "cmd/geth"
  ];
}
