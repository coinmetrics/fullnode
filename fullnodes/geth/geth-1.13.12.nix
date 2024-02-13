{ buildGoModule, fetchFromGitHub }:
buildGoModule rec {
  pname = "geth";
  version = "1.13.12";

  src = fetchFromGitHub {
    owner = "ethereum";
    repo = "go-ethereum";
    rev = "v${version}";
    # hash = "sha256-0000000000000000000000000000000000000000000=";
    hash = "sha256-0000000000000000000000000000000000000000000=";
  };

  # vendorHash = "sha256-0000000000000000000000000000000000000000000=";
  vendorHash = "sha256-LRB1JQ0O8f9TsoCjc7keXdJj4lkGnfbf6UaLmjevpzM=";

  subPackages = [
    "cmd/geth"
  ];

  # https://github.com/ethereum/go-ethereum/blob/ea9e62ca3db5c33aa7438ebf39c189afd53c6bf8/build/ci.go#L212
  tags = [ "urfave_cli_no_docs" ];
}
