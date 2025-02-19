{ buildGoModule, fetchFromGitHub }:
buildGoModule rec {
  pname = "geth";
  version = "1.15.2";

  src = fetchFromGitHub {
    owner = "ethereum";
    repo = "go-ethereum";
    rev = "v${version}";
    hash = "sha256-eaUkPl8vQzvotYfZcnuBwphSfO33RPjWOYhyNNvXli4=";
  };

  proxyVendor = true;
  vendorHash = "sha256-cfBTSroeDb/htGzIWG8c9Jty+Qo0TrQBrnyYy/Yo2C4=";

  subPackages = [
    "cmd/geth"
  ];

  # https://github.com/ethereum/go-ethereum/blob/ea9e62ca3db5c33aa7438ebf39c189afd53c6bf8/build/ci.go#L212
  tags = [ "urfave_cli_no_docs" ];
}