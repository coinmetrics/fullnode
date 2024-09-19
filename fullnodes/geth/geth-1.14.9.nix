{ buildGoModule, fetchFromGitHub }:
buildGoModule rec {
  pname = "geth";
  version = "1.14.9";

  src = fetchFromGitHub {
    owner = "ethereum";
    repo = "go-ethereum";
    rev = "v${version}";
    hash = "sha256-W0wHQMvbQJC3PdCZLVpE3cTasii/CkF+gdVOV2MX2Mo=";
  };

  proxyVendor = true;
  vendorHash = "sha256-Fxl8fisdCH0nlUFOS5NLMnvfpqIhlTd6/BbR+qIzlKQ==";

  subPackages = [
    "cmd/geth"
  ];

  # https://github.com/ethereum/go-ethereum/blob/ea9e62ca3db5c33aa7438ebf39c189afd53c6bf8/build/ci.go#L212
  tags = [ "urfave_cli_no_docs" ];
}
