{ buildGoModule, fetchFromGitHub }:
buildGoModule rec {
  pname = "geth";
  version = "1.14.5";

  src = fetchFromGitHub {
    owner = "ethereum";
    repo = "go-ethereum";
    rev = "v${version}";
    hash = "sha256-IY0BKoDRMVRZTIysdUgqhTFQx0Pz+kl61vbPbhSdT8k=";
  };

  proxyVendor = true;
  vendorHash = "sha256-vzxtoLlD1RjmKBpMPqcH/AAzk2l/NifpRl4Sp4qBYLg=";

  subPackages = [
    "cmd/geth"
  ];

  # https://github.com/ethereum/go-ethereum/blob/ea9e62ca3db5c33aa7438ebf39c189afd53c6bf8/build/ci.go#L212
  tags = [ "urfave_cli_no_docs" ];
}
