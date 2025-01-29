{ buildGo123Module, fetchFromGitHub }:
buildGo123Module rec {
  pname = "avalanche-rosetta";
  version = "0.1.47";

  src = fetchFromGitHub {
    owner = "ava-labs";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-XE6YD8do8Hcdcs15k0jL3MNWQ8G1zj5qcH1yX/2ntus=";
  };

  vendorHash = "sha256-fy6Pma55HzgAlfjBIDscxdkuAIPw/v8YfKq+Tq6B+NM=";

  proxyVendor = true;

  postInstall = ''
    mv $out/bin/{server,${pname}}
  '';
}
