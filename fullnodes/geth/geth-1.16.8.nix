{ buildGoModule, fetchFromGitHub }:
buildGoModule rec {
  pname = "geth";
  version = "1.16.8";

  src = fetchFromGitHub {
    owner = "ethereum";
    repo = "go-ethereum";
    rev = "v${version}";
    hash = "sha256-eMvLhOSWGC31ezZeqMMt8kmFHq9NU0kh5s2IBiw46NY=";
  };

  proxyVendor = true;
  vendorHash = "sha256-KP9oD87kn8MCvEf3ply8HbP8xIBlGAEtthGob8Yh++A=";

  subPackages = [
    "cmd/geth"
  ];

  # https://github.com/ethereum/go-ethereum/blob/ea9e62ca3db5c33aa7438ebf39c189afd53c6bf8/build/ci.go#L212
  tags = [ "urfave_cli_no_docs" ];
}
