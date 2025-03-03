{ buildGoModule, fetchFromGitHub }:
buildGoModule rec {
  pname = "geth";
  version = "1.15.4";

  src = fetchFromGitHub {
    owner = "ethereum";
    repo = "go-ethereum";
    rev = "v${version}";
    hash = "sha256-Vk/lrRmmRqPe2c6Ww8LPM1NrhZCmfeykXYZKVuXaDPU=";
  };

  proxyVendor = true;
  vendorHash = "sha256-byp1FzB4cSk9TayjaamsVfgzX0H531kzSXVHxDgWTes=";

  subPackages = [
    "cmd/geth"
  ];

  # https://github.com/ethereum/go-ethereum/blob/ea9e62ca3db5c33aa7438ebf39c189afd53c6bf8/build/ci.go#L212
  tags = [ "urfave_cli_no_docs" ];
}
