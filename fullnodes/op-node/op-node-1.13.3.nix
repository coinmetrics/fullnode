{ buildGoModule, fetchFromGitHub }:
buildGoModule rec {
  pname = "op-node";
  version = "1.13.2";

  src = fetchFromGitHub {
    owner = "ethereum-optimism";
    repo = "optimism";
    rev = "op-node/v${version}";
    hash = "sha256-WGmc59K2n6vPJdHlT2n4MN1f2J9KC9yU8nL7PJWeN6I=";
  };

  vendorHash = "sha256-eGTRQUd+WrQdiYGnhY8UmRwLvVA8cBTmYRd5Ciw/3HM=";

  subPackages = [
    "op-node/cmd"
  ];

  fixupPhase = ''
    mv $out/bin/cmd $out/bin/op-node
  '';
}
