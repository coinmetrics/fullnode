{ buildGoModule, fetchFromGitHub }:
buildGoModule rec {
  pname = "avalanche-rosetta";
  version = "0.1.49";

  src = fetchFromGitHub {
    owner = "ava-labs";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-6LysHWy1sYTYJr89hRXJfWPWsOnsUeyXsqmuulrb69A=";
  };

  vendorHash = "sha256-xD6ZbKo9pguH6nbFC6xeOrIBt3sjvBUovm3xcvTjaf0=";

  proxyVendor = true;

  postInstall = ''
    mv $out/bin/{server,${pname}}
  '';
}
