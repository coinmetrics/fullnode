{ buildGoModule, fetchFromGitHub }:
buildGoModule rec {
  pname = "geth";
  version = "1.17.3";

  src = fetchFromGitHub {
    owner = "ethereum";
    repo = "go-ethereum";
    rev = "v${version}";
    hash = "sha256-BLcpUbE2lkXkpzYWSIVaLNXlFTvSuXw9Vm0iTtrqOKQ=";
  };

  proxyVendor = true;
  vendorHash = "sha256-AOdGqr738EgwbZhHHP3ctQYUilgyOc/tIJyaI0H3oeM=";

  subPackages = [
    "cmd/geth"
  ];

  # https://github.com/ethereum/go-ethereum/blob/ea9e62ca3db5c33aa7438ebf39c189afd53c6bf8/build/ci.go#L212
  tags = [ "urfave_cli_no_docs" ];
}
