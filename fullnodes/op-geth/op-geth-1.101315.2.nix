{ buildGoModule, fetchFromGitHub }:
buildGoModule rec {
  pname = "op-geth";
  version = "1.101315.2";

  src = fetchFromGitHub {
    owner = "ethereum-optimism";
    repo = "op-geth";
    rev = "v${version}";
    hash = "sha256-29/96FIDwMKmvBQO6LfToquUUc+Ve6sa4VHeaBM/4Pw=";
  };

  vendorHash = "sha256-v+wgc1RrU8NoLgD+BRZjwMQf35yNnrWJBcQwmGkQWaY=";

  subPackages = [
    "cmd/geth"
  ];
}
