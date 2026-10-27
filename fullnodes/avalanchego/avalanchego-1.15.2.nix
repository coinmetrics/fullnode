{ buildGoModule
, fetchFromGitHub
, lib
, stdenv
}:

buildGoModule rec {
  pname = "avalanchego";
  version = "1.15.2";

  src = fetchFromGitHub {
    owner = "ava-labs";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-fItjOsCwupssk6wwbh0rVsbpjdlgc+AoZUfyX5g6RW0=";
  };

  vendorHash = "sha256-pw21akhnE4C1xs9vsBG9xPsYS9z6KxNgulk6H8vXYAs=";
  # go mod vendor has a bug, see: https://github.com/golang/go/issues/57529
  proxyVendor = true;

  subPackages = [ "main" ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/ava-labs/avalanchego/version.GitCommit=${version}"
  ];

  postInstall = ''
    mv $out/bin/{main,${pname}}
  '';

  meta = with lib; {
    description = "Go implementation of an Avalanche node";
    homepage = "https://github.com/ava-labs/avalanchego";
    changelog = "https://github.com/ava-labs/avalanchego/releases/tag/v${version}";
    license = licenses.bsd3;
    maintainers = with maintainers; [ urandom ];
  };
}
