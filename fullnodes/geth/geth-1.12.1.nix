{ buildGoModule, fetchFromGitHub }:
buildGoModule rec {
  pname = "geth";
  version = "1.12.1";

  src = fetchFromGitHub {
    owner = "ethereum";
    repo = "go-ethereum";
    rev = "refs/tags/v${version}";
    hash = "sha256-4kJ+Bf9xMQvxK759CsYQJ1qpWDFNihisyaU02Rsx4cE=";
  };

  #vendorHash = "sha256-0000000000000000000000000000000000000000000=";
  vendorHash = "sha256-IvT9MStNziC3qwVvsvufwRvHn0na1IxFLFi8XsvkNXc=";

  proxyVendor = true;
  doCheck = false;
}
