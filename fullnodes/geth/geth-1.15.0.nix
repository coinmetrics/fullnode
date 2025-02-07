{ buildGoModule, fetchFromGitHub }:
buildGoModule rec {
  pname = "geth";
  version = "1.15.0";

  src = fetchFromGitHub {
    owner = "ethereum";
    repo = "go-ethereum";
    rev = "v${version}";
    hash = "sha256-qfk9G3/wzeh8Nf7BG4Qv6It/bY1ZYoYyHsgoqgCyd6E=";
  };

  proxyVendor = true;
  vendorHash = "sha256-gTwmtrdj3+Pa4UxaUuhwk2Dtgur82Tbd0ict1cgVinw=";

  subPackages = [
    "cmd/geth"
  ];

  # https://github.com/ethereum/go-ethereum/blob/ea9e62ca3db5c33aa7438ebf39c189afd53c6bf8/build/ci.go#L212
  tags = [ "urfave_cli_no_docs" ];
}
