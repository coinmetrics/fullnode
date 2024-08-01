{ buildGoModule, fetchFromGitHub }:
buildGoModule rec {
  pname = "polygon-bor";
  version = "1.3.4";

  src = fetchFromGitHub {
    owner = "maticnetwork";
    repo = "bor";
    rev = "v${version}";
    hash = "sha256-auYgR+hZvTbuNT6QO5gQqy9WugzFrhypYVrakgO3MnQ=";
  };

  vendorHash = "sha256-qm+ZffrFSTV/GrJ44xIWLyurNx83kMapdYMKNNQ2jH4=";

  subPackages = [
    "cmd/cli"
  ];

  proxyVendor = true;

  # The tests may require docker
  doCheck = false;

  postInstall = ''
    mv $out/bin/cli $out/bin/bor
  '';
}
