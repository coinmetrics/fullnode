{ buildGoModule, fetchFromGitHub }:
buildGoModule rec {
  pname = "geth";
  version = "1.15.7";

  src = fetchFromGitHub {
    owner = "ethereum";
    repo = "go-ethereum";
    rev = "v${version}";
    hash = "sha256-auhH854yqyhimO71YSNQ0h6DI+iLGN1HP4KWpczytw4=";
  };

  proxyVendor = true;
  vendorHash = "sha256-1FuVdx84jvMBo8VO6q+WaFpK3hWn88J7p8vhIDsQHPM=";

  subPackages = [
    "cmd/geth"
  ];

  # https://github.com/ethereum/go-ethereum/blob/ea9e62ca3db5c33aa7438ebf39c189afd53c6bf8/build/ci.go#L212
  tags = [ "urfave_cli_no_docs" ];
}
