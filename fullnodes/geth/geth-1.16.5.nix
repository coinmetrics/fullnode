{ buildGoModule, fetchFromGitHub }:
buildGoModule rec {
  pname = "geth";
  version = "1.16.5";

  src = fetchFromGitHub {
    owner = "ethereum";
    repo = "go-ethereum";
    rev = "v${version}";
    hash = "sha256-f9MBHO3oh1Nh+YI1E8cPPaNRj4T12063YLqTDrdZWWA=";
  };

  proxyVendor = true;
  vendorHash = "sha256-6tGSyx4OXMXUjhIvLJo+vyRkNzHmwiikzrLL0cQPBLo=";

  subPackages = [
    "cmd/geth"
  ];

  # https://github.com/ethereum/go-ethereum/blob/ea9e62ca3db5c33aa7438ebf39c189afd53c6bf8/build/ci.go#L212
  tags = [ "urfave_cli_no_docs" ];
}
