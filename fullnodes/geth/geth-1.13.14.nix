{ buildGoModule, fetchFromGitHub }:
buildGoModule rec {
  pname = "geth";
  version = "1.13.14";

  src = fetchFromGitHub {
    owner = "ethereum";
    repo = "go-ethereum";
    rev = "v${version}";
    hash = "sha256-+o/yOsS8tm8zvTJ17jd+dNPJpJB0vsjf4WRWNv6HgG0=";
  };

  vendorHash = "sha256-LWNFuF66KudxrpWBBXjMbrWP5CwEuPE2h3kGfILIII0=";

  subPackages = [
    "cmd/geth"
  ];

  # https://github.com/ethereum/go-ethereum/blob/ea9e62ca3db5c33aa7438ebf39c189afd53c6bf8/build/ci.go#L212
  tags = [ "urfave_cli_no_docs" ];
}
