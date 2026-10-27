{ buildGoModule, fetchFromGitHub }:
buildGoModule rec {
  pname = "geth";
  version = "1.17.10";

  src = fetchFromGitHub {
    owner = "ethereum";
    repo = "go-ethereum";
    rev = "v${version}";
    hash = "sha256-ER95dQDnrSRq8lbno+nZzHSlDfhKc5EVZOODbsSiAZU=";
  };

  proxyVendor = true;
  vendorHash = "sha256-4Xi/33CwGfiikbv0yxcpM36VFGqcRLWXZjl6k0ILhRg=";

  subPackages = [
    "cmd/geth"
  ];

  # https://github.com/ethereum/go-ethereum/blob/ea9e62ca3db5c33aa7438ebf39c189afd53c6bf8/build/ci.go#L212
  tags = [ "urfave_cli_no_docs" ];
}
