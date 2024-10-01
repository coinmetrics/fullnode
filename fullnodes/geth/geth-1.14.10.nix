{ buildGoModule, fetchFromGitHub }:
buildGoModule rec {
  pname = "geth";
  version = "1.14.10";

  src = fetchFromGitHub {
    owner = "ethereum";
    repo = "go-ethereum";
    rev = "v${version}";
    hash = "sha256-6PvIlxXm1c9K+Jf1ERY0R24v3jb05+LwpMXv1LNM4gY=";
  };

  proxyVendor = true;
  vendorHash = "sha256-xPFTvzsHMWVyeAt7m++6v2l8m5ZvnLaIDGki/TWe5kU=";

  subPackages = [
    "cmd/geth"
  ];

  # https://github.com/ethereum/go-ethereum/blob/ea9e62ca3db5c33aa7438ebf39c189afd53c6bf8/build/ci.go#L212
  tags = [ "urfave_cli_no_docs" ];
}
