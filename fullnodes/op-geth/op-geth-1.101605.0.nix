{ buildGoModule, fetchFromGitHub }:
buildGoModule rec {
  pname = "op-geth";
  version = "1.101605.0";

  src = fetchFromGitHub {
    owner = "ethereum-optimism";
    repo = "op-geth";
    rev = "v${version}";
    hash = "sha256-hF+Ak+QjA+iH23WD/hWeTEpJxiDd055mXwFnX/5tOMc=";
  };

  vendorHash = "sha256-JdikHLS6txlilBdgyAEl/KL0lqEmb0QH8aoI4bkd7mM=";

  proxyVendor = true;

  subPackages = [
    "cmd/geth"
  ];
}
