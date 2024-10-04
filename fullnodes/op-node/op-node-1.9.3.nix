{ buildGoModule, fetchFromGitHub }:
buildGoModule rec {
  pname = "op-node";
  version = "1.9.3";

  src = fetchFromGitHub {
    owner = "ethereum-optimism";
    repo = "optimism";
    rev = "op-node/v${version}";
    hash = "sha256-bF64sM7j6UJZXbBcK/dNw5kRrnjWNOO5Vik5MuFEYR4=";
  };

  vendorHash = "sha256-qi3kdedbCfYObZbUlhPXlnw2TvAh086wXwE96BWAKiY=";

  subPackages = [
    "op-node/cmd"
  ];

  fixupPhase = ''
    mv $out/bin/cmd $out/bin/op-node
  '';
}
