{ buildGoModule
, fetchFromGitHub
, jq
, yq-go
, zip
}:
buildGoModule rec {
  pname = "op-node";
  version = "1.19.2";

  src = fetchFromGitHub {
    owner = "ethereum-optimism";
    repo = "optimism";
    rev = "op-node/v${version}";
    hash = "sha256-kHph82cZs5Qi/touVQu2dT4QybSbbyrjtn2lQfbd+zQ=";
    fetchSubmodules = true;
  };

  vendorHash = "sha256-HggYuu2zGgvznnDi27ZEpa872pf41rGzrDx79BKvA3U=";

  nativeBuildInputs = [
    jq
    yq-go
    zip
  ];

  preBuild = ''
    bash op-core/superchain/sync-superchain.sh
  '';

  subPackages = [
    "op-node/cmd"
  ];

  fixupPhase = ''
    mv $out/bin/cmd $out/bin/op-node
  '';
}
