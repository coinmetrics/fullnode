{ buildGoModule, fetchFromGitHub }:
buildGoModule rec {
  pname = "geth";
  version = "1.17.1";

  src = fetchFromGitHub {
    owner = "ethereum";
    repo = "go-ethereum";
    rev = "v${version}";
    hash = "sha256-Fg+xitRROkLVXIpCoQ78eY/RFRcj7pBPI4kTSLLl+pw=";
  };

  proxyVendor = true;
  vendorHash = "sha256-S/CkTWx4fUI54JVCW9ixhNADdBuMD2i7NI5U8aDy66k=";

  subPackages = [
    "cmd/geth"
  ];

  # https://github.com/ethereum/go-ethereum/blob/ea9e62ca3db5c33aa7438ebf39c189afd53c6bf8/build/ci.go#L212
  tags = [ "urfave_cli_no_docs" ];
}
