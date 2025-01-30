{ buildGoModule, fetchFromGitHub }:
buildGoModule rec {
  pname = "geth";
  version = "1.14.13";

  src = fetchFromGitHub {
    owner = "ethereum";
    repo = "go-ethereum";
    rev = "v${version}";
    hash = "sha256-oJe+V11WArXVmoIC7nYN6oKc0VoHtRtelidyb3v6skI=";
  };

  proxyVendor = true;
  vendorHash = "sha256-IEwy3XRyj+5GjAWRjPsd5qzwEMpI/pZIwPjKdeATgkE=";

  subPackages = [
    "cmd/geth"
  ];

  # https://github.com/ethereum/go-ethereum/blob/ea9e62ca3db5c33aa7438ebf39c189afd53c6bf8/build/ci.go#L212
  tags = [ "urfave_cli_no_docs" ];
}
