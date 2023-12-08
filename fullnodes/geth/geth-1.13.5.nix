{ buildGoModule, fetchFromGitHub }:
buildGoModule rec {
  pname = "geth";
  version = "1.13.5";

  src = fetchFromGitHub {
    owner = "ethereum";
    repo = "go-ethereum";
    rev = "v${version}";
    hash = "sha256-UbRsY9fSUYAwPcLfGGDHeqvSsLKUKR+2a93jH5xA9uQ=";
  };

  vendorHash = "sha256-dOvpOCMxxmcAaticSLVlro1L4crAVJWyvgx/JZZ7buE=";

  subPackages = [
    "cmd/geth"
  ];

  # https://github.com/ethereum/go-ethereum/blob/ea9e62ca3db5c33aa7438ebf39c189afd53c6bf8/build/ci.go#L212
  tags = [ "urfave_cli_no_docs" ];
}
