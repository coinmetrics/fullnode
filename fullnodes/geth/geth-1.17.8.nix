{ buildGoModule, fetchFromGitHub }:
buildGoModule rec {
  pname = "geth";
  version = "1.17.8";

  src = fetchFromGitHub {
    owner = "ethereum";
    repo = "go-ethereum";
    rev = "v${version}";
    hash = "sha256-Ev+Sb4YehsdrcYrnStmTk+jeh9idoUTLi+M3f4RERSg=";
  };

  proxyVendor = true;
  vendorHash = "sha256-ExyJ/GTzhN2YxEmUZGYd6dZst1eSPV1VvZkNaxpG9ro=";

  subPackages = [
    "cmd/geth"
  ];

  # https://github.com/ethereum/go-ethereum/blob/ea9e62ca3db5c33aa7438ebf39c189afd53c6bf8/build/ci.go#L212
  tags = [ "urfave_cli_no_docs" ];
}
