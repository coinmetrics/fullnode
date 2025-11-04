{ buildGoModule, fetchFromGitHub }:
buildGoModule rec {
  pname = "geth";
  version = "1.16.6";

  src = fetchFromGitHub {
    owner = "ethereum";
    repo = "go-ethereum";
    rev = "v${version}";
    hash = "sha256-aSckuL62ysOYPNjn/8ZGcm+0qG/VJ5SorVy8nCW6Gqg=";
  };

  proxyVendor = true;
  vendorHash = "sha256-o+hXnJe5oeOwroYMn2Xe0qoF4gHk10A5iKAE7BVUkEM=";

  subPackages = [
    "cmd/geth"
  ];

  # https://github.com/ethereum/go-ethereum/blob/ea9e62ca3db5c33aa7438ebf39c189afd53c6bf8/build/ci.go#L212
  tags = [ "urfave_cli_no_docs" ];
}
