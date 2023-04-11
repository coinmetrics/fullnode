{ buildGoModule, fetchFromGitHub }:
buildGoModule rec {
  pname = "bsc";
  version = "1.1.22";

  src = fetchFromGitHub {
    owner = "bnb-chain";
    repo = "bsc";
    rev = "refs/tags/v${version}";
    hash = "sha256-7sMjS8tUo14n1rlqMw8CFHyaG6WE2MMuHICk5P6QKs0=";
  };

  vendorSha256 = "sha256-sM5nh+Zw8xtVUUb9aXvdLYNODWX+k1tc1iMSM0uxJc8=";
  proxyVendor = true;

  subPackages = [
    "cmd/geth"
  ];
}
