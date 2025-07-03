{ buildGoModule, fetchFromGitHub }:
buildGoModule rec {
  pname = "geth";
  version = "1.16.1";

  src = fetchFromGitHub {
    owner = "ethereum";
    repo = "go-ethereum";
    rev = "v${version}";
    hash = "sha256-lsjs/bZhCwfp8OfTES1GDXayjDcg0R8+L0Z3pZ9/Mvs=";
  };

  proxyVendor = true;
  vendorHash = "sha256-Ggng6EDd5qRqcSbdycfivO8yiQcMOCSZt229JZcOlVs=";

  subPackages = [
    "cmd/geth"
  ];

  # https://github.com/ethereum/go-ethereum/blob/ea9e62ca3db5c33aa7438ebf39c189afd53c6bf8/build/ci.go#L212
  tags = [ "urfave_cli_no_docs" ];
}
