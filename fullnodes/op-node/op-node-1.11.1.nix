{ buildGoModule, fetchFromGitHub }:
buildGoModule rec {
  pname = "op-node";
  version = "1.11.1";

  src = fetchFromGitHub {
    owner = "ethereum-optimism";
    repo = "optimism";
    rev = "op-node/v${version}";
    hash = "sha256-9FYxOqJWM9MuVtMJzNmjvT/QE+g2/5jXsS3W7tIUzsg=";
  };

  vendorHash = "sha256-RQ+OuxAgTpQCfM7ZHhmE22gJTjckiEf4USMWteJmBpc=";

  subPackages = [
    "op-node/cmd"
  ];

  fixupPhase = ''
    mv $out/bin/cmd $out/bin/op-node
  '';
}
