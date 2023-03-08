{ buildGoModule, fetchFromGitHub }:
buildGoModule rec {
  pname = "geth";
  version = "1.11.3";

  vendorSha256 = "sha256-lcFtiw36Us38FA2jvkitbKoiz6JfRG/iMW3cQXqkUUs=";
  #vendorSha256 = "sha256-0000000000000000000000000000000000000000000=";

  src = fetchFromGitHub {
    owner = "ethereum";
    repo = "go-ethereum";
    rev = "refs/tags/v${version}";
    hash = "sha256-BFj2ggeBeL3THmwAPZqU5sn3bqtM3Kqc83TJ+Ldl/Ec=";
  };

  proxyVendor = true;
  doCheck = false;
}
