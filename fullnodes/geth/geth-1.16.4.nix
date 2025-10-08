{ buildGoModule, fetchFromGitHub }:
buildGoModule rec {
  pname = "geth";
  version = "1.16.4";

  src = fetchFromGitHub {
    owner = "ethereum";
    repo = "go-ethereum";
    rev = "v${version}";
    hash = "sha256-OlNbqKJUrpyFpsrkPu6mejLRYAPNkn6kI7HMvw9yjb8=";
  };

  proxyVendor = true;
  vendorHash = "sha256-m3rKGE3DDUEv1IJc/eAcVVGzXmaw7AjGIJ9iNzQFZtU=";

  subPackages = [
    "cmd/geth"
  ];

  # https://github.com/ethereum/go-ethereum/blob/ea9e62ca3db5c33aa7438ebf39c189afd53c6bf8/build/ci.go#L212
  tags = [ "urfave_cli_no_docs" ];
}
