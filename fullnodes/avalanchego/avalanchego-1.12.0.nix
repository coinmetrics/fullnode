{ IOKit
, buildGo122Module
, fetchFromGitHub
, lib
, stdenv
}:

buildGo122Module rec {
  pname = "avalanchego";
  version = "1.12.0";

  src = fetchFromGitHub {
    owner = "ava-labs";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-iedhLVNtwU8wSQIaq0r0fAYGH8fNnCRJW69D7wPdyx0=";
  };

  vendorHash = "sha256-CNwqpRx0HNvYfkowEEZe/Ue6W2FDZVAkUgof5QH9XkI=";
  # go mod vendor has a bug, see: https://github.com/golang/go/issues/57529
  proxyVendor = true;

  buildInputs = lib.optionals stdenv.isDarwin [ IOKit ];

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
