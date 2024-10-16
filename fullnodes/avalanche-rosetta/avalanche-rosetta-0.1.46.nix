{ buildGo122Module, fetchFromGitHub }:
buildGo122Module rec {
  pname = "avalanche-rosetta";
  version = "0.1.46";

  src = fetchFromGitHub {
    owner = "ava-labs";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-SlmO0pThcaVvx8tA7tEBvsXyQjVKonl9ybmL5ztplWA=";
  };

  vendorHash = "sha256-IArOOJdGjepGYrKrPk+znid2TNztcKSbANtsh8ZoCsM=";

  proxyVendor = true;

  postInstall = ''
    mv $out/bin/{server,${pname}}
  '';
}
