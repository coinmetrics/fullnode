{ buildGoModule, fetchFromGitHub }:
buildGoModule rec {
  pname = "op-node";
  version = "1.7.7";

  src = fetchFromGitHub {
    owner = "ethereum-optimism";
    repo = "optimism";
    rev = "op-node/v${version}";
    hash = "sha256-eHXUlPkpgNrwwPUoGedsDrtmAHrYmR1DVXty4UAzLEE=";
  };

  vendorHash = "sha256-MWGjRj5SMFi3O86l3Gc/oavzWd1TtoKr53eEXbCOamQ=";

  subPackages = [
    "op-node/cmd"
  ];

  fixupPhase = ''
    mv $out/bin/cmd $out/bin/op-node
  '';
}
