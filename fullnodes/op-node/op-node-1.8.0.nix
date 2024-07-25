{ buildGoModule, fetchFromGitHub }:
buildGoModule rec {
  pname = "op-node";
  version = "1.8.0";

  src = fetchFromGitHub {
    owner = "ethereum-optimism";
    repo = "optimism";
    rev = "op-node/v${version}";
    hash = "sha256-vHlAQ1DG87vcLE67wFmWTxfiIyw1xjO+GeqQ0IJIpDA=";
  };

  vendorHash = "sha256-UQ/appKaBvHkya9RNIYvSd4E+22DDFjJgJ3g82IShNY=";

  subPackages = [
    "op-node/cmd"
  ];

  fixupPhase = ''
    mv $out/bin/cmd $out/bin/op-node
  '';
}
