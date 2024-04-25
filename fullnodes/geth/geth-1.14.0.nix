{ buildGoModule, fetchFromGitHub }:
buildGoModule rec {
  pname = "geth";
  version = "1.14.0";

  src = fetchFromGitHub {
    owner = "ethereum";
    repo = "go-ethereum";
    rev = "v${version}";
    hash = "sha256-woEUUC+n5YN+TFFpGWchub9AQroITQZyGUcnvHEniQo=";
  };

  vendorHash = "sha256-u9m0umel7H3XXV7wwhhuxM8q3o9un5D+KTHagbcu7E0=";

  subPackages = [
    "cmd/geth"
  ];

  # https://github.com/ethereum/go-ethereum/blob/ea9e62ca3db5c33aa7438ebf39c189afd53c6bf8/build/ci.go#L212
  tags = [ "urfave_cli_no_docs" ];
}
