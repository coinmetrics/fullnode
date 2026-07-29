{ buildGoModule, fetchFromGitHub }:
buildGoModule rec {
  pname = "geth";
  version = "1.17.5";

  src = fetchFromGitHub {
    owner = "ethereum";
    repo = "go-ethereum";
    rev = "v${version}";
    hash = "sha256-KuXriZP3qMpChRF5hcQP2ZlmqUF5k+WcutDr3/oAI/0=";
  };

  proxyVendor = true;
  vendorHash = "sha256-kfVO/yeCDzYfKY4OWW6slT8Y2xrfO8BruKIcCZWW2P0=";

  subPackages = [
    "cmd/geth"
  ];

  # https://github.com/ethereum/go-ethereum/blob/ea9e62ca3db5c33aa7438ebf39c189afd53c6bf8/build/ci.go#L212
  tags = [ "urfave_cli_no_docs" ];
}
