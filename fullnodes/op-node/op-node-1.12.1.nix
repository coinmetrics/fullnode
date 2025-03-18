{ buildGoModule, fetchFromGitHub }:
buildGoModule rec {
  pname = "op-node";
  version = "1.12.1";

  src = fetchFromGitHub {
    owner = "ethereum-optimism";
    repo = "optimism";
    rev = "op-node/v${version}";
    hash = "sha256-QE5r4iEpE3MQ7UJTu3P9PC9yyoVDdYrrWAZqtvzltuY=";
  };

  vendorHash = "sha256-jAf+JwQ4zOGEEmjAg7L3kPE0TTT3XOifIWAJRQg60+w=";

  subPackages = [
    "op-node/cmd"
  ];

  fixupPhase = ''
    mv $out/bin/cmd $out/bin/op-node
  '';
}
