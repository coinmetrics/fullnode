{ buildGoModule, fetchFromGitHub }:
buildGoModule rec {
  pname = "geth";
  version = "1.17.4";

  src = fetchFromGitHub {
    owner = "ethereum";
    repo = "go-ethereum";
    rev = "v${version}";
    hash = "sha256-jgBKoSt3cdw3NyTi8SLBf28tvJIBAitkQNMlzfnIONE=";
  };

  proxyVendor = true;
  vendorHash = "sha256-18rqbSx3JGaQz3Fw38JShRikkTT4Gn+uqqbNZiJQaS8=";

  subPackages = [
    "cmd/geth"
  ];

  # https://github.com/ethereum/go-ethereum/blob/ea9e62ca3db5c33aa7438ebf39c189afd53c6bf8/build/ci.go#L212
  tags = [ "urfave_cli_no_docs" ];
}
