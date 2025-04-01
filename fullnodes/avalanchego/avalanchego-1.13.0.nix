{ IOKit
, buildGo123Module
, fetchFromGitHub
, lib
, stdenv
}:

buildGo123Module rec {
  pname = "avalanchego";
  version = "1.13.0";

  src = fetchFromGitHub {
    owner = "ava-labs";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-t6KruPHt51wJ4aJaCG/8tuwKYtaifHvQ3z9oVknNS4E=";
  };

  vendorHash = "sha256-iyx9k8mPPOwpHo9lEdNPf0sQHxbKbNTVLUZrPYY8dWM=";
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
