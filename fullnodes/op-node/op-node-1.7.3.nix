{ buildGoModule, fetchFromGitHub }:
buildGoModule rec {
  pname = "op-node";
  version = "1.7.3";

  src = fetchFromGitHub {
    owner = "ethereum-optimism";
    repo = "optimism";
    rev = "v${version}";
    hash = "sha256-7klbkrgqeJtoKKeHK6kPltDRi7tC5d9Lj8QEy3yA8CI=";
  };

  vendorHash = "sha256-pQhNXOYohBoV5QsBnNpNjFg+Vvk5jK1zvSKkolp4yiQ=";

  subPackages = [
    "op-node/cmd"
  ];

  fixupPhase = ''
    mv $out/bin/cmd $out/bin/op-node
  '';
}
