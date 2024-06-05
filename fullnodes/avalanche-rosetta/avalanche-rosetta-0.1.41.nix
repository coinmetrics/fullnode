{ buildGoModule, fetchFromGitHub }:
buildGoModule rec {
  pname = "avalanche-rosetta";
  version = "0.1.41";

  src = fetchFromGitHub {
    owner = "ava-labs";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-NyZVOFcP4XQDZfQG9/4CUJzkJ7S1gvEWbUEpPgPzkVM=";
  };

  vendorHash = "sha256-7qCuxo4uLoqM0JAZX/Te68OWYXAwfzBGVkc1g4A8gBo=";

  proxyVendor = true;

  postInstall = ''
    mv $out/bin/{server,${pname}}
  '';
}
