{ buildGoModule, fetchFromGitHub }:
buildGoModule rec {
  pname = "geth";
  version = "1.14.8";

  src = fetchFromGitHub {
    owner = "ethereum";
    repo = "go-ethereum";
    rev = "v${version}";
    hash = "sha256-y831v6ar1RdDvGQMZf2lZKgq2IQzAAQrNwDCL0xbj24=";
  };

  proxyVendor = true;
  vendorHash = "sha256-CLGf64Fftu4u8Vaj66Q4xuRKBEMNZmpltUyaUMVyVJk=";

  subPackages = [
    "cmd/geth"
  ];

  # https://github.com/ethereum/go-ethereum/blob/ea9e62ca3db5c33aa7438ebf39c189afd53c6bf8/build/ci.go#L212
  tags = [ "urfave_cli_no_docs" ];
}
