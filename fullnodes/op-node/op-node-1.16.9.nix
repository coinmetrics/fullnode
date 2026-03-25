{ buildGoModule, fetchFromGitHub }:
buildGoModule rec {
  pname = "op-node";
  version = "1.16.9";

  src = fetchFromGitHub {
    owner = "ethereum-optimism";
    repo = "optimism";
    rev = "op-node/v${version}";
    hash = "sha256-J95j2++TUMulekCLnO1PwnYSNLj6Uk04nW7jl+hLK6Y=";
  };

  vendorHash = "sha256-coL7jszEYfBEZnGEV+2KAp5CEwxAVUMBKDpjggz22oc=";

  subPackages = [
    "op-node/cmd"
  ];

  fixupPhase = ''
    mv $out/bin/cmd $out/bin/op-node
  '';
}
