{ buildGoModule, fetchFromGitHub }:
buildGoModule rec {
  pname = "geth";
  version = "1.16.3";

  src = fetchFromGitHub {
    owner = "ethereum";
    repo = "go-ethereum";
    rev = "v${version}";
    hash = "sha256-9g+RlOnV3DMLkak+RbSm8RgFB14Yuap8CT1w6kuZRv0=";
  };

  proxyVendor = true;
  vendorHash = "sha256-GEPSkuEdrYvPGXEGhAT3U765rjY6w6kwOVYOMCgOaCo=";

  subPackages = [
    "cmd/geth"
  ];

  # https://github.com/ethereum/go-ethereum/blob/ea9e62ca3db5c33aa7438ebf39c189afd53c6bf8/build/ci.go#L212
  tags = [ "urfave_cli_no_docs" ];
}
