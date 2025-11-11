{ buildGoModule, fetchFromGitHub }:
buildGoModule rec {
  pname = "op-node";
  version = "1.16.1";

  src = fetchFromGitHub {
    owner = "ethereum-optimism";
    repo = "optimism";
    rev = "op-node/v${version}";
    hash = "sha256-CeOH5UfYshBEnZ5hiyE9D3kBFYXCC/ZK1cpOqlR7go8=";
  };

  vendorHash = "sha256-vhksq7SFVuDUJb74CSjC+z+yh2cQ1yKnB1R925VAR2g=";

  subPackages = [
    "op-node/cmd"
  ];

  fixupPhase = ''
    mv $out/bin/cmd $out/bin/op-node
  '';
}
