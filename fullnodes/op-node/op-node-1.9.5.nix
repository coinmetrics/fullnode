{ buildGoModule, fetchFromGitHub }:
buildGoModule rec {
  pname = "op-node";
  version = "1.9.5";

  src = fetchFromGitHub {
    owner = "ethereum-optimism";
    repo = "optimism";
    rev = "op-node/v${version}";
    hash = "sha256-9ATxrxYbFDOAxzelmWvT3cjmO1j5pLluVu8iBKiXIEM=";
  };

  vendorHash = "sha256-1tZXG4eXB9LUZnHgKhNkphkFw2PLZjpelttpsdXAF/M=";

  subPackages = [
    "op-node/cmd"
  ];

  fixupPhase = ''
    mv $out/bin/cmd $out/bin/op-node
  '';
}
