{ buildGoModule, fetchFromGitHub }:
buildGoModule rec {
  pname = "geth";
  version = "1.17.6";

  src = fetchFromGitHub {
    owner = "ethereum";
    repo = "go-ethereum";
    rev = "v${version}";
    hash = "sha256-3dAzJitCXMP1fdrNKRWBYOEPfwQFOnQgLC08f/7+YwY=";
  };

  proxyVendor = true;
  vendorHash = "sha256-AsKicppcvr7xZ2sZ1pvsu8inXBRM1W3lFMlWAvV/EL0=";

  subPackages = [
    "cmd/geth"
  ];

  # https://github.com/ethereum/go-ethereum/blob/ea9e62ca3db5c33aa7438ebf39c189afd53c6bf8/build/ci.go#L212
  tags = [ "urfave_cli_no_docs" ];
}
