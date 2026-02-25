{ buildGoModule, fetchFromGitHub }:
buildGoModule rec {
  pname = "geth";
  version = "1.17.0";

  src = fetchFromGitHub {
    owner = "ethereum";
    repo = "go-ethereum";
    rev = "v${version}";
    hash = "sha256-xTx2gcpDY4xuZOuUEmtV6m5NNO6YQ01tGzLr5rh9F/g=";
  };

  proxyVendor = true;
  vendorHash = "sha256-egsqYaItRtKe97P3SDb6+7sbuvyGdNGIwCR6V2lgGOc=";

  subPackages = [
    "cmd/geth"
  ];

  # https://github.com/ethereum/go-ethereum/blob/ea9e62ca3db5c33aa7438ebf39c189afd53c6bf8/build/ci.go#L212
  tags = [ "urfave_cli_no_docs" ];
}
