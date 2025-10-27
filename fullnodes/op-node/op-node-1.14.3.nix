{ buildGoModule, fetchFromGitHub }:
buildGoModule rec {
  pname = "op-node";
  version = "1.14.3";

  src = fetchFromGitHub {
    owner = "ethereum-optimism";
    repo = "optimism";
    rev = "op-node/v${version}";
    hash = "sha256-0g1lO7vPRS9ZVBjd/i4RNA1PkJt+ZF4S5Hy8L2Z7jNo=";
  };

  vendorHash = "sha256-P8i4C6SNi76BhdUzAoQnfxA3gyr9BysogfochFdcCMI=";

  subPackages = [
    "op-node/cmd"
  ];

  fixupPhase = ''
    mv $out/bin/cmd $out/bin/op-node
  '';
}
